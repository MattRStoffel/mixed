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

    nixgl.url          = "github:nix-community/nixGL";
    nixgl.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, nix-darwin, home-manager, hardware, nixos-cli, ... } @ inputs:
  let
    lib = nixpkgs.lib;

    # Auto-imports every .nix file in a directory. Passed to standalone
    # home-manager hosts via extraSpecialArgs so they can self-select bundles.
    importDir = dir:
      let
        entries = builtins.readDir dir;
        files   = lib.filterAttrs (n: t: t == "regular" && builtins.match ".*\\.nix" n != null) entries;
        dirs    = lib.filterAttrs (n: t: t == "directory") entries;
      in
        map (name: dir + "/${name}") (builtins.attrNames files)
        ++ map (name: dir + "/${name}") (builtins.attrNames dirs);

    # NixOS hosts (includes home-manager as a NixOS module).
    # Apply with: sudo nixos-rebuild switch --flake .#<host>
    mkNixos = extraModules: nixpkgs.lib.nixosSystem {
      modules = [
        ./shared
        ./home
        home-manager.nixosModules.home-manager
        nixos-cli.nixosModules.nixos-cli
      ] ++ extraModules;
      specialArgs = { inherit inputs self; };
    };

    # Standalone home-manager hosts (non-NixOS — Arch, etc.).
    # Apply with: home-manager switch --flake .#<host>
    mkHome = { system, extraModules ? [] }:
      home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};
        modules = [ ./home/base.nix ] ++ extraModules;
        extraSpecialArgs = {
          inherit inputs self importDir;
          nixGLPkg = inputs.nixgl.packages.${system}.nixGLIntel;
        };
      };

  in {

    # ── macOS (nix-darwin) ────────────────────────────────────────────────────
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
    nixosConfigurations = {

      macbook = mkNixos [
        ./hosts/macbook
        hardware.nixosModules.apple-t2
      ];

      homeserver = mkNixos [
        ./hosts/homeserver
      ];

    };

    # ── Home Manager (non-NixOS) ──────────────────────────────────────────────
    homeConfigurations = {

      deck = mkHome {
        system = "x86_64-linux";
        extraModules = [ ./hosts/steamdeck ];
      };

    };

  };
}
