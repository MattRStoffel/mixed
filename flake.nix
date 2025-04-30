{
  description = "mixed";

  inputs = {
    hardware.url = "github:NixOS/nixos-hardware";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    ghostty.url = "github:ghostty-org/ghostty";
  };
  outputs = {
    self,
    nixpkgs,
    nix-darwin,
    home-manager,
    hardware,
    ghostty,
    ...
  } @ inputs: {
    nix.settings.experimental-features = ["nix-command" "flakes"];
    nixpkgs.config.allowUnfree = true;

    darwinConfigurations.macbook = nix-darwin.lib.darwinSystem {
      system = "x86_64-darwin";
      modules = [
        ./darwin
        home-manager.darwinModules.home-manager
      ];
      specialArgs = {
        inherit inputs;
        self = self;
      };
    };

    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      modules = [
        ./nixos
        hardware.nixosModules.apple-t2
        home-manager.nixosModules.home-manager
      ];
      specialArgs = {inherit inputs;};
    };
  };
}
