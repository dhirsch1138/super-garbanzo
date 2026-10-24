{ config, pkgs, ...}:
{

  security.protectKernelImage = true;

  # This option allows only users group to connect to the Nix daemon. 
  nix.settings.allowed-users = [ "@users" ];

  # disable kexec
  boot.kexec.enable = false;

}
