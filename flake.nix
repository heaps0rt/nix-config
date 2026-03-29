{
  description = "desktop config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, home-manager }: {
    nixosConfigurations.desktop = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ 
        ./configuration.nix 
        home-manager.nixosModules.home-manager {
          home-manager.useGlobalPkgs = true;   # use system nixpkgs
          home-manager.useUserPackages = true;  # install to user profile
          home-manager.users.heap = import ./home.nix;
        }
      ];
    };
  };
}
