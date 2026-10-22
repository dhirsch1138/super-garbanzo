{
  config,
  lib,
  pkgs,
  ...
}:

## Theming for waybar

with lib;
let
  cfg = config.programs.themes_waybar;

  cssStylePaths = {
    # Define the paths for the files directly as path literals
    "rose-pine" = {
      paletteFile = ./rose-pine/rose-pine.css;
      mapFile = ./map_rose-pine.css;
    };
    "rose-pine-dawn" = {
      paletteFile = ./rose-pine/rose-pine-dawn.css;
      mapFile = ./map_rose-pine.css;
    };
    "rose-pine-moon" = {
      paletteFile = ./rose-pine/rose-pine-moon.css;
      mapFile = ./map_rose-pine.css;
    };
  };

  # Select the chosen theme, falling back to "rose-pine" if not found
  currentTheme = cssStylePaths.${cfg.themeName} or cssStylePaths."rose-pine";

in
{
  options.programs.themes_waybar = {
    enable = mkEnableOption "enable application theme for waybar";
    themeName = mkOption {
      type = types.str;
      default = "rose-pine";
      description = "the theme to apply";
    };
  };

  config = mkIf cfg.enable {
    home.file.".config/waybar/style_map.css".source = currentTheme.mapFile;
    home.file.".config/waybar/palette.css".source = currentTheme.paletteFile;

    programs.waybar = {
      style = ./style.css;
    };
  };
}
