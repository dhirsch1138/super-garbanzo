{ config, pkgs, ... }:
{

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  #TODO if this ever is used on machine with intel or nvidia graphics add options

}
