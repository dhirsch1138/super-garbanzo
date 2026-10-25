{
  config,
  lib,
  pkgs,
  ...
}:

## Steam / Gaming

with lib;
let
  cfg = config.programs.steamwrapper;
in
{
  options.programs.steamwrapper = {
    enable = mkEnableOption "steam with configuration wrapper";
  };
  config = mkIf cfg.enable {
    programs.gamemode.enable = true;
    programs.steam = {
      enable = true; # Master switch, already covered in installation
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports for Source Dedicated Server hosting
      # Other general flags if available can be set here.
    };
  };
}
