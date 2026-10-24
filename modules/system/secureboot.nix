{ config, lib, pkgs, ... }:

## Secure Boot

with lib;
let
  cfg = config.boot.lanzabootewrapper;
in {
    options.boot.lanzabootewrapper = {
      enable = mkEnableOption "lanzaboote with configuration wrapper";
    };
  config = mkIf cfg.enable {
    
    environment.systemPackages = with pkgs; [
      sbctl
    ];
    
    # Lanzaboote currently replaces the systemd-boot module.
    # This setting is usually set to true in configuration.nix
    # generated at installation time. So we force it to false
    # for now.
    boot.loader.systemd-boot.enable = lib.mkForce false;

    boot.lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
    };
    
  };
}
