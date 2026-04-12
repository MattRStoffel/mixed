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

    hardware.url       = "github:NixOS/nixos-hardware"; # Apple T2 patches

    nixos-cli.url      = "github:nix-community/nixos-cli";
  };

  outputs = { self, nixpkgs, nix-darwin, home-manager, hardware, nixos-cli, ... } @ inputs: {

    # ── macOS ────────────────────────────────────────────────────────────────
    darwinConfigurations.macbook = nix-darwin.lib.darwinSystem {
      system = "x86_64-darwin";
      modules = [
        ./shared                              # shared: nix settings, user, timezone
        ./darwin                              # macOS: Dock, Finder, Homebrew, etc.
        ./home                               # home-manager: dotfiles & user programs
        home-manager.darwinModules.home-manager
      ];
      specialArgs = { inherit inputs self; };
    };

    # ── NixOS ────────────────────────────────────────────────────────────────
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      modules = [
        ./shared                              # shared: nix settings, user, timezone
        ./nixos                              # linux: boot, display, networking
        ./home                               # home-manager: dotfiles & user programs
        hardware.nixosModules.apple-t2       # Apple T2 kernel patches
        home-manager.nixosModules.home-manager
        nixos-cli.nixosModules.nixos-cli
      ];
      specialArgs = { inherit inputs self; };
    };
  };
}
