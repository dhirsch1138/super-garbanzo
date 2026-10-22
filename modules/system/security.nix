{ config, pkgs, ...}:
{

  security.protectKernelImage = true;

  # This option allows only users group to connect to the Nix daemon. 
  nix.settings.allowed-users = [ "@users" ];

  # disable kexec
  boot.kexec.enable = false;

  # Secure boot 
  # environment.systemPackages = with pkgs; [ sbctl ];
  # boot.loader.limine.enable = true;
  # this won't do anything on its own:
  # 1) create keys with sbctl
  # 2) enroll keys into UEFI
  # 3) enable secure boot option
  # boot.loader.limine.secureBoot.enable = true;
  # 
  # Check the wiki https://wiki.nixos.org/wiki/Limine
}
