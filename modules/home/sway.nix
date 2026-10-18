{ config, lib, pkgs, ... }:

{
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
      
      colors = {
        urgent = {
          background = "#eb6f92";
          border = "#eb6f92";
          childBorder = "#ebbcba";
          indicator = "#f6c177";
          text = "#e0def4";
        };
        focused = {
          background = "#31748f";
          border = "#31748f";
          childBorder = "#26233a";
          indicator = "#f6c177";
          text = "#e0def4";
        };
        unfocused = {
          background = "#908caa";
          border = "#908caa";
          childBorder = "#26233a";
          indicator = "#f6c177";
          text = "#e0def4";
        };
        background = "#191724";
        placeholder = {
          background = "";
          border = "#908caa";
          childBorder = "#26233a";
          indicator = "#f6c177";
          text = "#e0def4";
        };
        focusedInactive = {
          background = "#908caa";
          border = "#908caa";
          childBorder = "#26233a";
          indicator = "#f6c177";
          text = "#e0def4";
        };
      };

      modifier = "Mod4";
      keybindings = let inherit (config.home-manager.users.user.wayland.windowManager.sway.config) modifier menu;
      in lib.mkOptionDefault {
        # Brightness Controls
        "XF86MonBrightnessDown" = "exec light -U 10";
        "XF86MonBrightnessUp" = "exec light -A 10";
     
        # Volume Controls
        "XF86AudioRaiseVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ +1%";
        "XF86AudioLowerVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ -1%";
        "XF86AudioMute" = "exec pactl set-sink-mute @DEFAULT_SINK@ toggle";
      };
      startup = [
        { command = "kitten panel -o background=#191724 --edge=background sh -c 'cbonsai -i --life=70 --wait=600'"; }
        # force sway to go to workspace 1 on initial launch
        # for reasons I have yet to isolate it is going to 0
        { command = "swaymsg 'workspace 1'"; }
      ];
      window = {
        border = 3;
      };
    };
  };

  #Supporting services
  services.blueman-applet.enable = true;
   
  services.mako = {
    enable = true;
    settings = let inherit (config.home-manager.users.user.services.mako.config) modifier menu;
      in lib.mkOptionDefault {
        default-timeout = 10000;     
      };
  };

  services.network-manager-applet.enable = true;

  
}
