{ config, pkgs, ... }:
{

  services.udisks2.enable = true;
  # enable udiskie in HM to get auto mount
  # services.udiskie.enable = true;

}
