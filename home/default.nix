{lib, ...}: let
  importDir = dir:
    builtins.map
    (name: dir + "/${name}")
    (builtins.attrNames (lib.filterAttrs
      (name: type:
        type == "regular" && builtins.match ".*\\.nix" name != null)
      (builtins.readDir dir)));

  utilImports = importDir ./util;
  devImports = importDir ./dev;
  terminalImports = importDir ./terminal;
  appImports = importDir ./apps;
in {
  imports = terminalImports;

  home-manager.users.matt = {
    imports =
      [./nvim]
      ++ appImports
      ++ utilImports
      ++ devImports;

    home = {
      sessionVariables = {
        XDG_CONFIG_HOME = "$HOME/.config";
      };
      shellAliases = {
        ":q" = "exit";
        "top" = "top";
        "htop" = "btop";
        "cat" = "bat";
        "dog" = "bat";
        "benji" = "dog";
        "build" = "zig build -Dtarget=aarch64-linux-musl";
        "nix_init_env" = "function _nix_init(){ nix flake init --template \"https://flakehub.com/f/the-nix-way/dev-templates/*#${1}\"; }; _nix_init";
      };
      stateVersion = "24.11";
    };
  };
}
