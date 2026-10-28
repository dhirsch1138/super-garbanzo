{
  config,
  lib,
  pkgs,
  ...
}:

## Secure Boot w/ Lanzaboote support module
# ---
# If the sway lanzaboote module is enabled, this provides default configuration that supports it.
# The intent is that the configuration can just invoke:
#  programs.lanzaboote.enable = true;
# And automatically get the benefit of this supporting configuration, keeping the top level config clean.


let
  # Check if any user module defined systemd-boot.enable as true
  systemdBootRequested = any (def: def.value == true) (options.boot.loader.systemd-boot.enable.definitions or []);
in
{
  config = lib.mkIf config.boot.lanzaboote.enable {
    environment.systemPackages = with pkgs; [
      sbctl
    ];

    # Lanzaboote currently replaces the systemd-boot module.
    # This setting is usually set to true in configuration.nix
    # generated at installation time. So we force it to false
    # for now.
    # Log warning if systemd-boot 'was' part of the configuration
    warnings = lib.optional systemdBootRequested 
      "Warning: boot.loader.systemd-boot.enable is set to true, but Lanzaboote overrides it to false.";
    boot.loader.systemd-boot.enable = lib.mkForce false;

    boot.lanzaboote = {
      pkiBundle = lib.mkOptionDefault "/var/lib/sbctl";
      autoGenerateKeys.enable = lib.mkOptionDefault true;
      autoEnrollKeys.enable = lib.mkOptionDefault true;
    };   
  };
}
