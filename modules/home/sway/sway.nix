{
  config,
  osConfig,
  lib,
  pkgs,
  ...
}:

# This module provides a wrapper around the sway window manager to provide additional features and configuration options.
# This only takes effect when programs.sway.enable is set to true.

{

  config = lib.mkIf osConfig.programs.sway.enable {
    wayland.windowManager.sway = {
      enable = true;
      wrapperFeatures.gtk = true;
      config = {
        bars = [
          {
            id = "waybar";
            command = "waybar";
          }
        ];
        modifier = "Mod4";
        keybindings =
          let
            inherit (config.home-manager.users.user.wayland.windowManager.sway.config) modifier menu;
          in
          lib.mkDefault {
            # Brightness Controls
            "XF86MonBrightnessDown" = "exec light -U 10";
            "XF86MonBrightnessUp" = "exec light -A 10";

            # Volume Controls
            "XF86AudioRaiseVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ +1%";
            "XF86AudioLowerVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ -1%";
            "XF86AudioMute" = "exec pactl set-sink-mute @DEFAULT_SINK@ toggle";
          };
        startup = [
          {
            command = "kitten panel -o background=#191724 --edge=background sh -c 'cbonsai -i --life=70 --wait=600'";
          }
          # force sway to go to workspace 1 on initial launch
          # for reasons I have yet to isolate it is going to 0
          { command = "swaymsg 'workspace 1'"; }
        ];
        window = {
          border = 3;
        };
      };
      extraConfig = ''
        hide_edge_borders smart_no_gaps
      '';
    };

    #Supporting programs

    # kitty is used for the bonsai background effect in swaywm
    programs.kitty = {
      enable = true;
    };

    # Supporting services

    # enable udisks2 to allow for mounting of usb drives
    services.udiskie.enable = true;

    # enable bluetooth applet for bluetooth management
    services.blueman-applet.enable = true;

    # enable mako for notifications
    services.mako = {
      enable = true;
      settings =
        let
          inherit (config.home-manager.users.user.services.mako.config) modifier menu;
        in
        lib.mkDefault {
          default-timeout = 10000;
        };
    };

    # enable network manager applet for network management UI (tray icon)
    services.network-manager-applet.enable = true;

  };
}
