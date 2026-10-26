{ config, pkgs, ... }:
{
  # All of the modules that should be imported for home-manager configurations
  imports = [
    ./sway
    ./vscode.nix
    ./themes
  ];

}
