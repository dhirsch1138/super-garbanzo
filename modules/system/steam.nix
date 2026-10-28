{
  config,
  lib,
  pkgs,
  ...
}:

# Steam support module
# ---
# If the steam program module is enabled, this provides default configuration that supports steam.
# The intent is that the configuration can just invoke:
#  programs.steam.enable = true;
# And automatically get the benefit of this supporting configuration, keeping the top level config clean.

let
in
{
  config = lib.mkIf config.programs.steam.enable {
    programs.gamemode.enable = lib.mkDefault true;
    programs.steam = {
      remotePlay.openFirewall = lib.mkDefault true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = lib.mkDefault true; # Open ports for Source Dedicated Server hosting
      # Other general flags if available can be set here.
    };
  };
}
