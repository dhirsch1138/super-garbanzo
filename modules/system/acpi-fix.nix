{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.boot.acpiFix;
in {
  options.boot.acpiFix = {
    enableForce = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to add the "acpi=force" kernel parameter to resolve 
        shutdown and suspend hangs on affected hardware.
      '';
    };

    enableEnforceResourcesLax = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to add the "acpi_enforce_resources=lax" kernel parameter 
        to bypass strict safety checks on ACPI resource regions during shutdown.
      '';
    };
  };

  config = mkMerge [
    (mkIf cfg.enableForce {
      boot.kernelParams = [ "acpi=force" ];
    })

    (mkIf cfg.enableEnforceResourcesLax {
      boot.kernelParams = [ "acpi_enforce_resources=lax" ];
    })
  ];
}
