{ config, pkgs, ... }:
{

  services.ollama = {
    enable = false;
    package = pkgs.ollama-vulkan;
  };

}
