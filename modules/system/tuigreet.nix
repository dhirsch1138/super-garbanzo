{ config, pkgs, ...}:
{
 #TODO: This is hard coded for sway, make this option in future
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --background doom --cmd sway";
        user = "greeter";
      };
    };
  };

  security.pam.services = {
    greetd.enableGnomeKeyring = true;
  };   
}
