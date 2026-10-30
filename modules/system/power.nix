{ config, pkgs, ... }:
{

  # Enables toggling of power profiles
  services.power-profiles-daemon.enable = true;

  # Thermald proactively prevents overheating on Intel CPUs and works well with other tools.
  services.thermald.enable = true;

  # Run rfkill block all on shutdown to help prevent bluetooth and wifi
  # from preventing shutdown.
  systemd.services.run-on-shutdown = {
    description = "Run custom command on shutdown";
    wantedBy = [
      "halt.target"
      "poweroff.target"
      "reboot.target"
    ];
    before = [
      "halt.target"
      "poweroff.target"
      "reboot.target"
    ];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "/bin/true";
      ExecStop = "${pkgs.util-linux}/bin/rfkill block all";
    };
  };

  # Run rfkill block all on suspend to help prevent bluetooth and wifi from preventing sleep.
  systemd.services.run-on-suspend = {
    description = "Run custom command before going to sleep";
    wantedBy = [ "sleep.target" ];
    before = [ "sleep.target" ];

    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.util-linux}/bin/rfkill block all";
    };
  };

  # Run rfkill unblock all on resume to re-enable bluetooth and wifi after waking up.
  systemd.services.run-on-resume = {
    description = "Run custom command after waking up";
    wantedBy = [ "post-resume.target" ];
    after = [ "post-resume.target" ];

    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.util-linux}/bin/rfkill unblock all";
    };
  };
  # TODO add module to enable TLP

}
