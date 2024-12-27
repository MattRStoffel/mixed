{
  description = "nixos config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    hardware.url = "github:nixos/nixos-hardware";
    home.url = "github:nix-community/home-manager";
     ghostty = { url = "github:ghostty-org/ghostty"; };
  };

  outputs = {nixpkgs, hardware, home, ghostty, ...} : {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      modules = [
	hardware.nixosModules.apple-t2
        ./configuration.nix
	home.nixosModules.home-manager
      ];
    };
  };
}
