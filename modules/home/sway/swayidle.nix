{
  config,
  osConfig,
  lib,
  pkgs,
  ...
}:

# This module provides a wrapper around the sway window manager to provide additional features and configuration options.
# This module sets up swayidle to manage idle timeouts and locking.
# This only takes effect when programs.sway.enable is set to true.

{

  config = lib.mkIf osConfig.programs.sway.enable {
    services.swayidle =
      let
        # Lock command
        lock = "${pkgs.swaylock}/bin/swaylock --daemonize";
        # TODO: modify "display" function based on your window manager
        # Sway
        display = status: "${pkgs.sway}/bin/swaymsg 'output * power ${status}'";
        # Hyprland
        # display = status: "hyprctl dispatch dpms ${status}";
        # Niri
        # display = status: "${pkgs.niri}/bin/niri msg action power-${status}-monitors";
      in
      {
        enable = true;
        timeouts = [
          {
            timeout = 555; # in seconds
            command = "${pkgs.libnotify}/bin/notify-send 'Locking in 5 seconds' -t 5000";
          }
          {
            timeout = 600;
            command = lock;
          }
          {
            timeout = 900;
            command = display "off";
            resumeCommand = display "on";
          }
          {
            timeout = 1200;
            command = "${pkgs.systemd}/bin/systemctl suspend";
          }
        ];
        events = {
          "before-sleep" = (display "off") + "; " + lock + "; rfkill block all";
          "after-resume" = display "on" + "; rfkill unblock all";
          "lock" = (display "off") + "; " + lock;
          "unlock" = display "on";
        };
      };

  };
}
