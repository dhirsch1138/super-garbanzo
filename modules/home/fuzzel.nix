{
  config,
  osConfig,
  lib,
  pkgs,
  ...
}:
let
  swayUsesFuzzel = config.wayland.windowManager.sway.config.menu == "fuzzel";
in
{
  # Enable fuzzel if sway is enabled. Fuzzel is a lightweight and fast application launcher for Wayland compositors
  config = lib.mkIf swayUsesFuzzel {
    programs.fuzzel = {
      enable = true;
      settings = {
        main = {
          font = "FiraCode Nerd Font:size=12";
          lines = 5;
        };
        colors = {
          background = "14161Be5";
          text = "F5F5F5FF";
          selection-match = "A2D6F9ff";
          match = "A2D6F9ff";
          selection = "4F5258ff";
          selection-text = "F5F5F5FF";
          border = "A1A1A1FF";
        };
        border = {
          radius = 0;
          width = 1;
        };
      };
    };
  };
}
