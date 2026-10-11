{ config, lib, pkgs, ... }:

{
  # Import files from the current configuration directory into the Nix store,
  # and create symbolic links pointing to those store files in the Home directory.

  imports =
    [
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
  
    # editors
    geany
 
    # images
    imv

    # file handling
    lf

    # misc
    bat
    cbonsai
    cowsay
    file
    fortune
    which
    tree
    gawk
    gnupg

    # nix related
    #
    # it provides the command `nom` works just like `nix`
    # with more details log output
    nix-output-monitor

    # productivity
    hugo # static site generator
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

  programs.fzf = {
    enable = false;
    enableBashIntegration = true;
  };

  # basic configuration of git, please change to your own
  programs.git = {
    enable = true;
    settings.user = {
      name = "d";
      email = "dhirsch1138@gmail.com";
    };
  };
 
  programs.kitty = {
    enable = true;
  };
 
  programs.bash = {
    enable = true;
    enableCompletion = true;
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
