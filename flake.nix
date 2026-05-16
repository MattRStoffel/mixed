# =============================================================================
# flake.nix — Entry point. Manages macOS (nix-darwin) and NixOS from one repo.
# =============================================================================
{
  description = "mixed";

  inputs = {
    nixpkgs.url        = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin.url     = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url   = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    hardware.url       = "github:NixOS/nixos-hardware";

    nixos-cli.url      = "github:nix-community/nixos-cli";
  };

  outputs = { self, nixpkgs, nix-darwin, home-manager, hardware, nixos-cli, ... } @ inputs:
  let
    # Shared base modules for every NixOS host.
    mkNixos = extraModules: nixpkgs.lib.nixosSystem {
      modules = [
        ./shared
        ./home
        home-manager.nixosModules.home-manager
        nixos-cli.nixosModules.nixos-cli
      ] ++ extraModules;
      specialArgs = { inherit inputs self; };
    };
  in {

    # ── macOS ─────────────────────────────────────────────────────────────────
    darwinConfigurations.macbook = nix-darwin.lib.darwinSystem {
      system = "x86_64-darwin";
      modules = [
        ./shared
        ./darwin
        ./home
        home-manager.darwinModules.home-manager
      ];
      specialArgs = { inherit inputs self; };
    };

    # ── NixOS ─────────────────────────────────────────────────────────────────
    # Build:  sudo nixos-rebuild switch --flake .#<host>
    nixosConfigurations = {

      macbook = mkNixos [
        ./hosts/macbook
        hardware.nixosModules.apple-t2
      ];

      steamdeck = mkNixos [
        ./hosts/steamdeck
      ];

      homeserver = mkNixos [
        ./hosts/homeserver
      ];

    };
  };
}
