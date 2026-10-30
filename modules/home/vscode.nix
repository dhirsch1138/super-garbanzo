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

  configureVscodePythonScript =
    pkgs.writers.writePython3 "configure-vscode-argv"
      {
        libraries = [ ];
      }
      ''
        import json
        import os

        path = os.path.expanduser("~/.vscode/argv.json")
        os.makedirs(os.path.dirname(path), exist_ok=True)

        if not os.path.exists(path):
            with open(path, "w") as f:
                f.write('{\n    "password-store": "gnome-libsecret"\n}\n')
        else:
            with open(path, "r") as f:
                content = f.read()

            lines = [
                line for line in content.splitlines()
                if not line.strip().startswith("//")
            ]
            clean_content = "\n".join(lines)

            has_correct_store = False
            try:
                data = json.loads(clean_content)
                if data.get("password-store") == "gnome-libsecret":
                    has_correct_store = True
            except Exception:
                pass

            if not has_correct_store:
                try:
                    data = json.loads(clean_content)
                except Exception:
                    data = {}

                if "password-store" not in data:
                    last_brace = content.rfind("}")
                    if last_brace != -1:
                        prefix = content[:last_brace].rstrip()
                        if not prefix.endswith(",") and not prefix.endswith("{"):
                            prefix = prefix + ","
                        new_entry = '\n    "password-store": "gnome-libsecret"\n'
                        new_content = prefix + new_entry + content[last_brace:]
                        with open(path, "w") as f:
                            f.write(new_content)
                else:
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
