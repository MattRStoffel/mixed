{
  description = "mixed";

  inputs = {
    hardware.url = "github:NixOS/nixos-hardware";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };
  outputs = {
    self,
    nixpkgs,
    nix-darwin,
    home-manager,
    hardware,
    ...
  } @ inputs: {
    darwinConfigurations.macbook = nix-darwin.lib.darwinSystem {
      system = "x86_64-darwin";
      modules = [
        ./darwin
        ./home
        ./shared
        home-manager.darwinModules.home-manager
      ];
      specialArgs = {
        inherit inputs self;
      };
    };

    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      modules = [
        ./shared
        ./nixos
        ./home
        # hardware.nixosModules.apple-t2
        home-manager.nixosModules.home-manager
      ];
      specialArgs = {inherit inputs self;};
    };
  };
}
