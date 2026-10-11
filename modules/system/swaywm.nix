{ config, pkgs, ...}:
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

  services.gnome.gnome-keyring.enable = true;

  security.pam.services = {
    swaylock.enableGnomeKeyring = true;
  #  gdm.enableGnomeKeyring = true;
  };

}
