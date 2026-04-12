{ lib, pkgs, ... }:
let
  # Auto-discovers .nix files in each subdirectory so you never need to
  # manually add imports — just drop a file in the right folder.
  importDir = dir:
    let
      entries = builtins.readDir dir;
      files = lib.filterAttrs (n: t: t == "regular" && builtins.match ".*\\.nix" n != null) entries;
      dirs  = lib.filterAttrs (n: t: t == "directory") entries;
    in
      builtins.map (name: dir + "/${name}") (builtins.attrNames files)
      ++ builtins.map (name: dir + "/${name}") (builtins.attrNames dirs);

  appImports      = importDir ./apps;
  utilImports     = importDir ./util;
  devImports      = importDir ./dev;
  terminalImports = importDir ./terminal;
in {

  imports = terminalImports;
  home-manager.backupFileExtension = "backup";

  home-manager.users.matt = {
    imports = []
      ++ appImports
      ++ utilImports
      ++ devImports;

    home = {
      packages = with pkgs; [
      ];

      sessionVariables = {
        XDG_CONFIG_HOME = "$HOME/.config";
        EDITOR          = "nvim";
        TERM            = "ghostty";
      };

      shellAliases = {
        ":q"    = "exit";
        "htop"  = "btop";
        "cat"   = "bat";
        "dog"   = "bat";
        "benji" = "dog";
      };

      stateVersion = "26.05";
    };
  };
}
