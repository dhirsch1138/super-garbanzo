{
  description = "A simple NixOS flake";
  # I love that description. I refuse to change it.

  inputs = {
    # NixOS official package source, using the nixos-26.05 branch here
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    # Secure boot support
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.2.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Home Manager for user level configuration
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      # The `follows` keyword in inputs is used for inheritance.
      # Here, `inputs.nixpkgs` of home-manager is kept consistent with
      # the `inputs.nixpkgs` of the current flake,
      # to avoid problems caused by different versions of nixpkgs.
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Slow Flakes for delayed flake.lock updates
    slowflakes = {
      url = "github:dhirsch1138/slowflakes/main";
      inputs.nixpkgs.follows = "nixpkgs"; # Bind to host system nixpkgs
    };
  };

  outputs =
    {
      self,
      home-manager,
      slowflakes,
      lanzaboote,
      nixpkgs,
      ...
    }@inputs:
    {
      # Helios is my personal desktop
      nixosConfigurations.helios = nixpkgs.lib.nixosSystem {
        modules = [
          # Import the previous configuration.nix we used,
          # so the old configuration file still takes effect
          ./hosts/helios/configuration.nix

          # helios should use the personalDesktop.nix configuration
          ./roles/personalDesktop.nix

          # make home-manager as a module of nixos
          # so that home-manager configuration will be deployed automatically when executing `nixos-rebuild switch`
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            home-manager.users.david = import ./users/david/home.nix;

            # Use home-manager.extraSpecialArgs to pass custom arguments to ./home.nix
            # Uncomment the next line to make all flake inputs available in home.nix
            # home-manager.extraSpecialArgs = inputs;
          }

          # Import lanzaboote module
          lanzaboote.nixosModules.lanzaboote

          # Import slowflakes module
          slowflakes.nixosModules.default
        ];
      };
    };
}
