{ self, pkgs, lib, importDir, nixGLPkg, ... }:
let
  # Wraps a package so all its binaries run through nixGLIntel (Mesa/AMD).
  # Passes through .override/.overrideAttrs so home-manager modules that call
  # package.override { ... } (e.g. Firefox) continue to work.
  nixGLWrap = pkg:
    let
      wrapped = pkgs.symlinkJoin {
        name        = "${pkg.pname or pkg.name}-nixgl";
        paths       = [ pkg ];
        buildInputs = [ pkgs.makeWrapper ];
        postBuild   = ''
          for bin in ${pkg}/bin/*; do
            name=$(basename "$bin")
            rm -f "$out/bin/$name"
            makeWrapper ${nixGLPkg}/bin/nixGLIntel "$out/bin/$name" \
              --add-flags "$bin"
          done
        '';
      };
    in
      wrapped
      // lib.optionalAttrs (pkg ? override)     { override     = args: nixGLWrap (pkg.override args); }
      // lib.optionalAttrs (pkg ? overrideAttrs) { overrideAttrs = f:   nixGLWrap (pkg.overrideAttrs f); };
in {
  imports =
    (importDir "${self}/home/shell") ++
    (importDir "${self}/home/cli") ++
    (importDir "${self}/home/apps") ++
    (importDir "${self}/home/dev") ++
    (importDir "${self}/home/games");

  # Wrap home.packages apps via overlay so legcord.nix / libreoffice.nix /
  # nextcloud.nix pick up the wrapped version without modification.
  nixpkgs.overlays = [
    (_: prev: {
      legcord          = nixGLWrap prev.legcord;
      libreoffice      = nixGLWrap prev.libreoffice;
      nextcloud-client = nixGLWrap prev.nextcloud-client;
      prismlauncher    = nixGLWrap prev.prismlauncher;
    })
  ];

  # Wrap programs.* apps by overriding their package.
  programs.ghostty.package       = nixGLWrap pkgs.ghostty;
  programs.google-chrome.package = nixGLWrap pkgs.google-chrome;
  programs.firefox.package       = nixGLWrap pkgs.firefox;
  programs.obsidian.package      = nixGLWrap pkgs.obsidian;

  home.username      = "deck";
  home.homeDirectory = "/home/deck";
  home.stateVersion  = "26.05";
  # System-level config (bluetooth, gamescope) managed by Arch/pacman.
}
