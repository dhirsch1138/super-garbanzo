{ config, pkgs, ... }:
{
  # All of the modules that should be imported for home-manager configurations
  imports = [
    ./fuzzel.nix
    ./sway
    ./themes
    ./vscode.nix
  ];

}
