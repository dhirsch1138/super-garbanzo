{
  config,
  lib,
  pkgs,
  ...
}:

{
  # Import files from the current configuration directory into the Nix store,
  # and create symbolic links pointing to those store files in the Home directory.

  imports = [
    ./modules/default_home.nix
  ];

  # home.file.".config/i3/wallpaper.jpg".source = ./wallpaper.jpg;

  # Import the scripts directory into the Nix store,
  # and recursively generate symbolic links in the Home directory pointing to the files in the store.
  # home.file.".config/i3/scripts" = {
  #   source = ./scripts;
  #   recursive = true;   # link recursively
  #   executable = true;  # make all files executable
  # };

  # encode the file content in nix configuration file directly
  # home.file.".xxx".text = ''
  #     xxx
  # '';

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    # here is some command line tools I use frequently
    # feel free to add your own or remove some of them

    nnn # terminal file manager

    # archives
    zip
    xz
    unzip
    p7zip

    # audio
    pavucontrol
    pamixer

    # ide
    vscode

    # editors
    geany

    # images
    imv

    # file browser
    lf
    thunar

    # file handlers
    jq

    # misc
    bat
    cbonsai
    cmatrix
    file
    fortune
    which
    tree
    gawk
    gnupg

    #themes
    # nwg-look
    # rose-pine-gtk-theme
    # rose-pine-icon-theme
    # rose-pine-cursor

    # nix related
    #
    # it provides the command `nom` works just like `nix`
    # with more details log output
    nil
    nix-output-monitor
    nixfmt

    # productivity
    glow # markdown previewer in terminal

    # system call monitoring
    lsof # list open files
  ];

  programs.firefox = {
    enable = true;
  };

  programs.foot = {
    enable = true;
    settings = {
      main = {
        dpi-aware = "yes";
        font = "monospace:size=11";
        term = "xterm-256color";
      };
      mouse = {
        hide-when-typing = "yes";
      };
    };
  };

  # basic configuration of git, please change to your own
  programs.git = {
    enable = true;
    settings.user = {
      name = "d";
      email = "dhirsch1138@gmail.com";
    };
    settings = {
      safe.directory = "*";
    };
  };

  programs.kitty = {
    enable = true;
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;
  };

  programs.vscode = {
    enable = true;
  };

  home.activation.configureVscodeArgv = ''
    VSCODE_DIR="$HOME/.vscode"
    ARGV_FILE="$VSCODE_DIR/argv.json"

    # 1. Create the .vscode directory if it doesn't exist
    mkdir -p "$VSCODE_DIR"

    # 2. Initialize argv.json with default JSON if it doesn't exist
    if [ ! -f "$ARGV_FILE" ]; then
      echo '{}' > "$ARGV_FILE"
    fi

    # 3. Use jq to upsert/add the password-store entry without destroying other settings
    TMP_FILE=$(mktemp)
    jq '. + {"password-store": "gnome-libsecret"}' "$ARGV_FILE" > "$TMP_FILE"
    mv "$TMP_FILE" "$ARGV_FILE"

    # 4. Ensure it remains writable by the user
    chmod 644 "$ARGV_FILE"
  '';

  services.udiskie.enable = true;

  programs.themes_sway = {
    enable = true;
    themeName = "rose-pine-moon";
  };

  programs.themes_waybar = {
    enable = true;
    themeName = "rose-pine-moon";
  };
  
  gtk = {
    enable = true;
    iconTheme = {
      package = pkgs.rose-pine-icon-theme;
      name = "rose-pine-moon";
    };
    theme = { 
      package = pkgs.rose-pine-gtk-theme;
      name = "rose-pine-rose";
    };
  };

  # This value determines the home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "26.05";
}
