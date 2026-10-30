{
  config,
  osConfig,
  lib,
  pkgs,
  ...
}:

## VSCode wrapper module

with lib;
let
  isGnomeKeyringEnabled =
    (config.services.gnome-keyring.enable or false)
    || (osConfig.services.gnome.gnome-keyring.enable or false);

  hasSecretService = isGnomeKeyringEnabled;

  configureVscodePythonScript = pkgs.writers.writePython3 "configure-vscode-argv" {
    libraries = [ ];
  } ''
    import json
    import os

    path = os.path.expanduser("~/.vscode/argv.json")
    data = {}

    os.makedirs(os.path.dirname(path), exist_ok=True)

    if os.path.exists(path):
        try:
            with open(path, "r") as f:
                content = f.read().strip()
                if content:
                    # Filter out single-line // comments
                    lines = [
                        line for line in content.splitlines()
                        if not line.strip().startswith("//")
                    ]
                    data = json.loads("\n".join(lines))
        except Exception:
            data = {}

    if data.get("password-store") != "gnome-libsecret":
        data["password-store"] = "gnome-libsecret"
        with open(path, "w") as f:
            json.dump(data, f, indent=4)
            f.write("\n")

    if os.path.exists(path):
        os.chmod(path, 0o644)
  '';
in
{
  config = mkIf config.programs.vscode.enable {

    home.packages = with pkgs; [
      nil
      nixfmt
      cowsay
    ];

    home.activation.configureVscodeArgv = lib.mkIf hasSecretService ''
      ${configureVscodePythonScript}
    '';
  };
}
