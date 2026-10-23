{ pkgs, cfg, stateDir, ... }:

let
  updateScript = pkgs.writeShellApplication {
    name = "slowflakes-update";
    runtimeInputs = [ pkgs.git ];
    text = ''
      set -euo pipefail
      DELAY_DAYS="''${1:-${toString cfg.delayDays}}"
      TARGET_STATE_DIR="${stateDir}"
      EXPECTED_REPO_PATH="${cfg.repoPath}"

      CURRENT_DIR="$(pwd)"
      if [ ! -f "flake.nix" ]; then
        echo "Error: No 'flake.nix' found in the current working directory." >&2
        exit 1
      fi

      case "$CURRENT_DIR" in
        "$EXPECTED_REPO_PATH"*)
          ;;
        *)
          echo "Error: 'slowflakes-update' must be run from within the configured repository path ($EXPECTED_REPO_PATH)." >&2
          echo "Current working directory is: $CURRENT_DIR" >&2
          exit 1
          ;;
      esac

      if [ ! -d "$TARGET_STATE_DIR/.git" ]; then
        echo "Error: Isolated state repository not found at $TARGET_STATE_DIR." >&2
        echo "Has the systemd background service run at least once?" >&2
        exit 1
      fi

      echo "Fetching historical lock from isolated state repository..."
      COMMIT_HASH=$(git -C "$TARGET_STATE_DIR" rev-list -n 1 --before="''${DELAY_DAYS} days ago" HEAD 2>/dev/null || true)

      if [ -z "$COMMIT_HASH" ]; then
        echo "Error: No commit found in state repo older than ''${DELAY_DAYS} days." >&2
        exit 1
      fi

      LATEST_COMMIT_HASH=$(git -C "$TARGET_STATE_DIR" rev-list -n 1 HEAD)
      LATEST_COMMIT_DATE=$(git -C "$TARGET_STATE_DIR" log -1 --format="%ct" "$LATEST_COMMIT_HASH")
      CURRENT_TIMESTAMP="$(date +%s)"
      SECONDS_IN_DAY=86400
      THRESHOLD_SECONDS=$(( DELAY_DAYS * SECONDS_IN_DAY ))
      AGE_SECONDS=$(( CURRENT_TIMESTAMP - LATEST_COMMIT_DATE ))

      if [ "$AGE_SECONDS" -ge "$THRESHOLD_SECONDS" ]; then
        echo ""
        echo "################################################################################"
        echo "WARNING: STALENESS ALERT! No new updates have been committed to the isolated"
        echo "state repository in the last $DELAY_DAYS days (or longer)!"
        echo "The newest available snapshot is older than your configured delay threshold."
        echo "Check your background systemd timer ('slowflakes-localrepo-update.service') or network status."
        echo "################################################################################"
        echo ""
      fi

      TARGET_DATE=$(git -C "$TARGET_STATE_DIR" log -1 --format="%ct" "$COMMIT_HASH")
      LOCAL_LOCK_DATE=$(git log -1 --format="%ct" -- flake.lock || echo "0")

      if [ "$TARGET_DATE" -le "$LOCAL_LOCK_DATE" ]; then
        echo "Warning: The selected $DELAY_DAYS-day-old lock is older than or equal to your current local flake.lock modification." >&2
        echo "This usually happens if you recently applied a manual security hotfix on 'main'." >&2
        echo "Aborting to prevent overwriting your newer lockfile." >&2
        exit 1
      fi

      COMMIT_DATE=$(git -C "$TARGET_STATE_DIR" log -1 --format="%ci" "$COMMIT_HASH")
      echo "Found qualifying lock from state repo: $COMMIT_DATE ($COMMIT_HASH)"

      git -C "$TARGET_STATE_DIR" show "$COMMIT_HASH:flake.lock" > ./flake.lock

      if git diff --quiet flake.lock; then
        echo "flake.lock is already aligned with the commit from ''${DELAY_DAYS} days ago."
      else
        echo "Success: Updated flake.lock in working directory from isolated history. Ready to review or rebuild!"
      fi
    '';
  };

  statusScript = pkgs.writeShellApplication {
    name = "slowflakes-status";
    runtimeInputs = [ pkgs.git ];
    text = ''
      set -euo pipefail
      TARGET_STATE_DIR="${stateDir}"

      echo "=== Slowflakes Status Diagnostic ==="
      echo "State Directory: $TARGET_STATE_DIR"

      if [ ! -d "$TARGET_STATE_DIR/.git" ]; then
        echo "Status: Isolated state repository not initialized yet."
        exit 0
      fi

      TOTAL_SNAPSHOTS=$(git -C "$TARGET_STATE_DIR" rev-list --count HEAD)
      OLDEST_COMMIT=$(git -C "$TARGET_STATE_DIR" log --reverse --format="%ci" -n 1)
      LATEST_COMMIT=$(git -C "$TARGET_STATE_DIR" log -1 --format="%ci (%h)")

      echo "Total Stored Snapshots: $TOTAL_SNAPSHOTS"
      echo "Oldest Snapshot Date:   $OLDEST_COMMIT"
      echo "Latest Snapshot Date:   $LATEST_COMMIT"
      echo ""
      echo "Recent Historical Snapshots:"
      git -C "$TARGET_STATE_DIR" log -n 5 --format="  - [%h] %ad : %s" --date=short
    '';
  };

  cleanupScript = pkgs.writeShellApplication {
    name = "slowflakes-cleanup";
    runtimeInputs = [ pkgs.git ];
    text = ''
      set -euo pipefail
      TARGET_STATE_DIR="${stateDir}"

      if [ ! -d "$TARGET_STATE_DIR" ]; then
        echo "State directory $TARGET_STATE_DIR does not exist. Nothing to clean."
        exit 0
      fi

      echo "WARNING: You are about to execute: sudo rm -rf '$TARGET_STATE_DIR'"
      echo "This will completely destroy the isolated rolling state repository and all its update history."
      echo "The background systemd service will re-initialize it fresh on its next run."
      read -rp "Are you sure you want to proceed? [y/N] " response

      case "$response" in
        [yY][eE][sS]|[yY])
          echo "Purging $TARGET_STATE_DIR..."
          sudo rm -rf "$TARGET_STATE_DIR"
          echo "Success: Isolated state repository cleared."
          ;;
        *)
          echo "Aborted."
          exit 0
          ;;
      esac
    '';
  };
in {
  inherit updateScript statusScript cleanupScript;
}
