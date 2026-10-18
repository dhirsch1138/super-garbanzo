{ config, lib, pkgs, ... }:

let
 
  #base
  border_unfocused = "#2a273f";
  background_unfocused = border_unfocused;
  #highlightMed
  border_focused = "#44415a";  
  background_focused = border_focused; 
 
  #overlay
  childborder = "#393552";

  #text
  text = "#e0def4";

  #rose
  border_urgent = "#f6c117";
  background_urgent = border_urgent;

  #highlightHigh
  indicator = "#56526e";
  
in

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
          background = background_urgent;
          border = border_urgent;
          childBorder = childborder;
          indicator = indicator;
          text = text;
        };
        focused = {
          background = background_focused;
          border = border_focused;
          childBorder = childborder;
          indicator = indicator;
          text = text;
        };
        unfocused = {
          background = background_unfocused;
          border = childborder;
          childBorder = childborder;
          indicator = border_unfocused;
          text = text;
        };
        background = background_unfocused;
        placeholder = {
          background = "";
          border = border_unfocused;
          childBorder = childborder;
          indicator = indicator;
          text = text;
        };
        focusedInactive = {
          background = background_unfocused;
          border = border_focused;
          childBorder = childborder;
          indicator = indicator;
          text = text;
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
