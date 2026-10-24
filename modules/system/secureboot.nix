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
  };
}
