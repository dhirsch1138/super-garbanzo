{ config, lib, pkgs, ... }:

{
  # Import files from the current configuration directory into the Nix store,
  # and create symbolic links pointing to those store files in the Home directory.

  imports =
    [
      .modules/default_home.nix
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


  services.blueman-applet.enable = true;

  services.network-manager-applet.enable = true;

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
      #{
      #  timeout = 1200;
      #  command = "${pkgs.systemd}/bin/systemctl suspend";
      #}
    ];
    events = {
     "before-sleep" = (display "off") + "; " + lock;
     "after-resume" = display "on";
     "lock" = (display "off") + "; " + lock;
     "unlock" = display "on";
    };
  };

  wayland.windowManager.sway = {
    enable = true;
    config = {
      bars = [
        {
          id = "waybar";
          command = "waybar";
        }
      ];
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
        { command = "kitten panel --edge=background sh -c 'cbonsai -i --life=70 --wait=600'"; }
        # force sway to go to workspace 1 on initial launch
        # for reasons I have yet to isolate it is going to 0
        { command = "swaymsg 'workspace 1'"; }
      ];
      window = {
        border = 3;
      };
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
