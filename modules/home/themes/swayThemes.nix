{ config, lib, pkgs, ... }:

## Theming for sway

with lib;
let
  cfg = config.programs.themes_sway;

  # Define themes in a lookup table using recursive attribute sets (rec)
  themes = {
    "rose-pine-moon" = rec {
      # base
      border_unfocused = "#232136";
      background_unfocused = border_unfocused;
      # highlightMed
      border_focused = "#44415a";  
      background_focused = border_focused; 
      # overlay
      childborder = "#393552";
      # text
      text = "#e0def4";
      # rose
      border_urgent = "#f6c117";
      background_urgent = border_urgent;
      # highlightHigh
      indicator = "#56526e";
    };
    "rose-pine" = rec {
      # base
      border_unfocused = "#191724";
      background_unfocused = border_unfocused;
      # highlightMed
      border_focused = "#403d52";  
      background_focused = border_focused; 
      # overlay
      childborder = "#26233a";
      # text
      text = "#e0def4";
      # rose
      border_urgent = "#ebbcba";
      background_urgent = border_urgent;
      # highlightHigh
      indicator = "#524f67";
    };
  };

  # Select the chosen theme, falling back to "rose-pine" if not found
  currentTheme = themes.${cfg.themeName} or themes."rose-pine";

in {
  options.programs.themes_sway = {
    enable = mkEnableOption "enable theme application for sway";
    themeName = mkOption {
      type = types.str;
      default = "rose-pine";
      description = "the theme to apply";
    };
  };

  config = mkIf cfg.enable {
    wayland.windowManager.sway = {
      config = {
        colors = {
          urgent = {
            background = currentTheme.background_urgent;
            border = currentTheme.border_urgent;
            childBorder = currentTheme.childborder;
            indicator = currentTheme.indicator;
            text = currentTheme.text;
          };
          focused = {
            background = currentTheme.background_focused;
            border = currentTheme.border_focused;
            childBorder = currentTheme.childborder;
            indicator = currentTheme.indicator;
            text = currentTheme.text;
          };
          unfocused = {
            background = currentTheme.background_unfocused;
            border = currentTheme.childborder;
            childBorder = currentTheme.childborder;
            indicator = currentTheme.border_unfocused;
            text = currentTheme.text;
          };
          background = currentTheme.background_unfocused;
          placeholder = {
            background = "";
            border = currentTheme.border_unfocused;
            childBorder = currentTheme.childborder;
            indicator = currentTheme.indicator;
            text = currentTheme.text;
          };
          focusedInactive = {
            background = currentTheme.background_unfocused;
            border = currentTheme.border_focused;
            childBorder = currentTheme.childborder;
            indicator = currentTheme.indicator;
            text = currentTheme.text;
          };
        };
      };
    };
  };
}
