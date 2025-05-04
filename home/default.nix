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
in {
  imports = terminalImports;

  home-manager.users.matt = {
    imports =
      [./nvim]
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
      };
      stateVersion = "24.11";
    };
  };
}
