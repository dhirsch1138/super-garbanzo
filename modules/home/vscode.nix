{
  config,
  lib,
  pkgs,
  ...
}:

## VSCode wrapper module

with lib;
let
  cfg = config.programs.vscodewrapper;
in
{
  options.programs.vscodewrapper = {
    enable = mkEnableOption "enable vscode w/ supporting configuration";
  };

  config = mkIf cfg.enable {
    programs.vscode = {
      enable = true;
    };

    home.packages = with pkgs; [
      jq
      nil
      nixfmt
      vscode
    ];

    # vscode isn't seeing that gnome keyring is setup
    # so we have to explicitly *add* it to the argument json
    # VSCode gets very cranky if it can write to this file, so
    # avoiding using the home manager option for direct update
    # w/ activation script
    home.activation.configureVscodeArgv = ''
      VSCODE_DIR="$HOME/.vscode"
      ARGV_FILE="$VSCODE_DIR/argv.json"

      # 1. Create the .vscode directory if it doesn't exist
      mkdir -p "$VSCODE_DIR"

      # 2. Initialize argv.json with default JSON if it doesn't exist
      if [ ! -f "$ARGV_FILE" ]; then
        echo '{}' > "$ARGV_FILE"
      fi

      # 3. Use jq to upsert/add the password-store entry without destroying other settings
      TMP_FILE=$(mktemp)
      jq '. + {"password-store": "gnome-libsecret"}' "$ARGV_FILE" > "$TMP_FILE"
      mv "$TMP_FILE" "$ARGV_FILE"

      # 4. Ensure it remains writable by the user
      chmod 644 "$ARGV_FILE"
    '';
  };
}
