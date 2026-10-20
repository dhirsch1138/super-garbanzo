{ config, lib, pkgs, ... }:

## Theming for waybar

with lib;
let
  cfg = config.programs.themes_waybar;

  cssStylePaths = {
  #Define the paths for the css file(s) utilized for each style
  #  all paths must be relative to pwd of this nix file
  #  pallet files will be staged in relative path to ~/.config/waybar/
  # palleteFile is the color pallete provided by the theme
  # mapFile is maps the theme pallete to standard names
    "rose-pine" = rec {
      palleteFile = rose-pine/rose-pine.css;
      mapFile = map_rose-pine.css;
     };
  };

  # Select the chosen theme, falling back to "rose-pine" if not found
  currentTheme = cssStylePaths.${cfg.themeName} or cssStylePaths."rose-pine";

  palleteFileTarget = ".config/waybar/" + currentTheme.palleteFile;

in {
  options.programs.themes_waybar = {
    enable = mkEnableOption "enable application theme for waybar";
    themeName = mkOption {
      type = types.str;
      default = "rose-pine";
      description = "the theme to apply";
    };
  };

  config = mkIf cfg.enable {
    home.file.".config/waybar/style.css".source = ./style.css;
    home.file.".config/waybar/style_map.css".source = "./" + currentTheme.mapFile;
    home.file.palleteFileTarget.source = "./" + currentTheme.palleteFile;
    
    programs.waybar = {
      style = "./style.css";
    };
  };
}
