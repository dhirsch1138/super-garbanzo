{
  config,
  lib,
  pkgs,
  ...
}:

## Steam helpers
let
in
{
  config = lib.mkIf config.programs.steam.enable {
    programs.gamemode.enable = true;
    programs.steam = {
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports for Source Dedicated Server hosting
      # Other general flags if available can be set here.
    };
  };
}
