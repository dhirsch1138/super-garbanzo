{ config, lib, pkgs, ... }:

{

  home.file.".config/waybar/rose-pine/rose-pine.css".source = ./rose-pine/rose-pine.css;
  home.file.".config/waybar/rose-pine/rose-pine-dawn.css".source = ./rose-pine/rose-pine-dawn.css;
  home.file.".config/waybar/rose-pine/rose-pine-moon.css".source = ./rose-pine/rose-pine-moon.css;

  home.file.".config/waybar/style_map.css".source = ./map_rose-pine.css;

#  home.file.".config/waybar/style.css".source = ./style.css;

  programs.waybar = {
    enable = true;
    style = ./style.css;
    settings = {
      mainBar = let inherit (config.home-manager.users.user.programs.waybar.settings) modifier menu;
      in lib.mkOptionDefault {
        layer = "top";
        position = "top";
        height = 30;
        spacing = 4;
        modules-left = [
          "sway/workspaces"
          "sway/mode"
          "sway/scratchpad"
          "custom/media"
        ];
        modules-center = [
          "sway/window"
        ];
        modules-right = [
          "mpd"
          "idle_inhibitor"
          "pulseaudio"
          "network"
          "power-profiles-daemon"
          "cpu"
          "memory"
          "temperature"
          "backlight"
          "keyboard-state"
          "battery"
          "clock"
          "tray"
        ];
        "clock" =  {
        # timezone = "America/New_York";
        tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        format-alt =  "{:%Y-%m-%d}";
        };
        cpu =  {
          format = "{usage}% ";
          tooltip = false;
        };
        memory =  {
          format = "{}% ";
        };
        temperature = {
          # "thermal-zone": 2,
          # "hwmon-path": "/sys/class/hwmon/hwmon2/temp1_input",
          critical-threshold = 80;
          # "format-critical": "{temperatureC}°C {icon}",
          format = "{temperatureC}°C {icon}";
          format-icons= ["" "" ""];
        };
        backlight = {
          # "device": "acpi_video1",
          format = "{percent}% {icon}";
          format-icons = ["" "" "" "" "" "" "" "" ""];
          min-brightness = 1;
        };
        battery = {
          states = {
            good = 95;
            warning = 30;
            critical = 15;
          };
          format = "{capacity}% {icon}";
          format-full = "{capacity}% {icon}";
          format-charging = "{capacity}% ";
          format-plugged = "{capacity}% ";
          format-alt = "{time} {icon}";
          format-good = ""; # An empty format will hide the module
          # format-full = "";
          format-icons = ["" "" "" "" ""];
        };
        idle_inhibitor = {
          format= "{icon}";
          format-icons = {
            activated = "";
            deactivated = "";
          };
        };
        power-profiles-daemon = {
          format = "{icon}";
          # tooltip-format = "Power profile: {profile}\nCPU driver: {cpu_driver}\nPlatform driver: {platform_driver}";
          # tooltip = true;
          format-icons = {
            default = "";
            performance = "";
            balanced = "";
            power-saver = "";
          };
        };
        network = {
          # "interface": "wlp2*", // (Optional) To force the use of this interface
          format-wifi = "{essid} ({signalStrength}%) ";
          format-ethernet = "{ipaddr}/{cidr} ";
          tooltip-format = "{ifname} via {gwaddr} ";
          format-linked = "{ifname} (No IP) ";
          format-disconnected = "Disconnected ⚠";
          format-alt = "{ifname}: {ipaddr}/{cidr}";
        };
        pulseaudio = {
        #// "scroll-step": 1, #  %, can be a float
          format = "{volume}% {icon} {format_source}";
          format-bluetooth = "{volume}% {icon} {format_source}";
          format-bluetooth-muted = "{icon} {format_source}";
          format-muted = " {format_source}";
          format-source = "{volume}% ";
          format-source-muted = "";
          format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = ["" "" ""];
          };
        on-click = "pavucontrol";
        };
      };
    };
  };
}
