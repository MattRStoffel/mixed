{ lib, pkgs, ... }:
let
  # Auto-discovers .nix files in each subdirectory so you never need to
  # manually add imports — just drop a file in the right folder.
  importDir = dir:
    builtins.map
      (name: dir + "/${name}")
      (builtins.attrNames (lib.filterAttrs
        (name: type: type == "regular" && builtins.match ".*\\.nix" name != null)
        (builtins.readDir dir)));

  appImports      = importDir ./apps;
  utilImports     = importDir ./util;
  devImports      = importDir ./dev;
  terminalImports = importDir ./terminal;
in {

  imports = terminalImports;
  home-manager.backupFileExtension = "backup";

  home-manager.users.matt = {
    imports =
      [ ./nvim ]
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
