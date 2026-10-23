{ config, lib, pkgs, ... }:

let
  cfg = config.services.slowflakes;
  stateDir = "/var/lib/${cfg.stateFolderName}";
in {
  config = lib.mkIf cfg.enable {
    nix.settings.allowed-users = [ "slowflakes-bot" ];

    users.users.slowflakes-bot = {
      isSystemUser = true;
      group = "slowflakes-bot";
      description = "System user for slowflakes-bot background repository automation";
      home = stateDir;
    };
    users.groups.slowflakes-bot = {};

    systemd.services.slowflakes-localrepo-update = lib.mkIf cfg.enableLocalAutomation {
      description = "Automated daily update for isolated delayed flake state repo";
      path = [ pkgs.git pkgs.nix pkgs.iputils ];

      script = ''
        set -euo pipefail
        TARGET_STATE_DIR="${stateDir}"

        echo "Starting slowflakes isolated state update routine..."
        echo "Target state directory: $TARGET_STATE_DIR"

        ${lib.optionalString cfg.networkCheckEnabled ''
        echo "Checking network connectivity before attempting upstream update..."
        if ! ping -c 1 -W 3 8.8.8.8 >/dev/null 2>&1 && ! ping -c 1 -W 3 1.1.1.1 >/dev/null 2>&1; then
          echo "Notice: Network connectivity could not be confirmed (offline or unreachable)."
          echo "Exiting gracefully without failing systemd unit."
          exit 0
        fi
        echo "Network connectivity confirmed."
        ''}

        if [ ! -d "$TARGET_STATE_DIR/.git" ]; then
          echo "Isolated state repository not found. Initializing fresh repository at $TARGET_STATE_DIR..."
          git -C "$TARGET_STATE_DIR" init -b main
          git -C "$TARGET_STATE_DIR" config user.name "${cfg.gitUserName}"
          git -C "$TARGET_STATE_DIR" config user.email "${cfg.gitUserEmail}"
          
          if [ -f "${cfg.repoPath}/flake.nix" ]; then
            echo "Seeding initial baseline flake.nix and flake.lock from ${cfg.repoPath}..."
            cp ${cfg.repoPath}/flake.nix "$TARGET_STATE_DIR/"
            cp ${cfg.repoPath}/flake.lock "$TARGET_STATE_DIR/" || true
            git -C "$TARGET_STATE_DIR" add flake.nix flake.lock || true
            git -C "$TARGET_STATE_DIR" commit -m "Initial baseline seed" || true
            echo "Baseline seed successfully committed."
          else
            echo "Notice: No baseline flake.nix found at ${cfg.repoPath} during bootstrap initialization. Deferring seed until next run."
            exit 0
          fi
        fi

        cd "$TARGET_STATE_DIR"
        git config user.name "${cfg.gitUserName}"
        git config user.email "${cfg.gitUserEmail}"

        if [ -f "${cfg.repoPath}/flake.nix" ]; then
          echo "Synchronizing latest flake.nix from primary repository (${cfg.repoPath})..."
          cp "${cfg.repoPath}/flake.nix" ./flake.nix
        fi

        echo "Running 'nix flake update' to fetch latest upstream changes..."
        nix flake update
        echo "Upstream update completed successfully."

        if ! git diff --quiet || ! git diff --cached --quiet; then
          echo "Changes detected in flake files. Staging and committing update in isolated repo..."
          git add flake.nix flake.lock
          git commit -m "chore(flake): automated state update $(date +'%Y-%m-%d')"
          echo "Successfully committed new state snapshot to isolated repo history."

          RETENTION_DAYS=$(( ${toString cfg.delayDays} * 3 ))
          CUTOFF_COMMIT=$(git rev-list -n 1 --before="''${RETENTION_DAYS} days ago" HEAD 2>/dev/null || true)

          if [ -n "$CUTOFF_COMMIT" ]; then
            echo "Pruning Git history older than $RETENTION_DAYS days..."
            PARENT_COMMIT=$(git rev-parse "$CUTOFF_COMMIT~1" 2>/dev/null || true)
            if [ -n "$PARENT_COMMIT" ]; then
              git checkout --orphan temp-branch "$CUTOFF_COMMIT"
              git commit -C "$CUTOFF_COMMIT" -m "chore(flake): compacted history baseline $(date +'%Y-%m-%d')"
              git branch -D main
              git branch -m main
              git gc --prune=now --aggressive >/dev/null 2>&1 || true
              echo "History successfully pruned and compacted."
            fi
          fi
        else
          echo "No upstream changes detected. Isolated state repository is already up to date."
        fi

        echo "Slowflakes background update routine completed successfully."
      '';
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        User = "slowflakes-bot";
        Group = "slowflakes-bot";
        StateDirectory = cfg.stateFolderName;
        StateDirectoryMode = "0755";
        PrivateDevices = true;
      };
    };

    systemd.timers.slowflakes-localrepo-update = lib.mkIf cfg.enableLocalAutomation {
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = "daily";
        Persistent = true;
      };
    };
  };
}
