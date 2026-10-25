{ config, pkgs, ... }:
{

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    mako
    wl-clipboard
  ];

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };

  # gsettings
  programs.dconf.enable = true;

  # GNOME Keyring is used to store secrets (like passwords)
  services.gnome.gnome-keyring.enable = true;

  # allow swaylock to (un)lock gnome keyring
  security.pam.services = {
    swaylock.enableGnomeKeyring = true;
    #  gdm.enableGnomeKeyring = true;
  };

  # enable tumbler for thumbnail generation in file managers like thunar
  services.tumbler.enable = true;

  # Thunar will serve as the GUI file manager for the sway session
  programs.thunar = {
    enable = true;
  };

  # Enable xfconf to allow for thunar to work outside of xfce4 session.
  programs.xfconf.enable = true;

  # Plugins for thunar to allow for archive management and automounting of external drives
  programs.thunar.plugins = with pkgs; [
    thunar-archive-plugin
    thunar-volman
  ];

  # GNOME Virtual file service (for things like trash folder)
  services.gvfs.enable = true;

}
