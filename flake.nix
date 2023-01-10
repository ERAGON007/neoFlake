{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-unstable;
    home-manager = {
      url = github:nix-community/home-manager;
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      pkgs = {
        inherit system;
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
      };
      lib = nixpkgs.lib;
    in {
      nixosConfigurations = {
        eragon = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./configuration.nix

            home-manager.nixosModules.home-manager
            ({
            home-manager.backupFileExtension = "backup";
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.eragon = import ./home;

            # Optionally, use home-manager.extraSpecialArgs to pass
            # arguments to home.nix
            })
          ];
        };
      };
  };
}
