{
  description = "nixos config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    hardware.url = "github:nixos/nixos-hardware";
    home.url = "github:nix-community/home-manager";
    xencelabs.url = "github:nilp0inter/nixos-xencelabs";
  };

  outputs = {nixpkgs, hardware, home, xencelabs, ...} : {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      modules = [
	hardware.nixosModules.apple-t2
        ./configuration.nix
	home.nixosModules.home-manager
	xencelabs.nixosModules.xencelabs
      ];
    };
  };
}
