{ lib, config, ... }:
let
  importDir = dir:
    let
      entries = builtins.readDir dir;
      files   = lib.filterAttrs (n: t: t == "regular" && builtins.match ".*\\.nix" n != null) entries;
      dirs    = lib.filterAttrs (n: t: t == "directory") entries;
    in
      map (name: dir + "/${name}") (builtins.attrNames files)
      ++ map (name: dir + "/${name}") (builtins.attrNames dirs);

  hmBundles = {
    shell   = importDir ./shell;
    cli     = importDir ./cli;
    dev     = importDir ./dev;
    desktop = importDir ./desktop;
    apps    = importDir ./apps;
  };

  mkHmImports = username:
    let disabled = lib.attrByPath [ username "disabledBundles" ] [] config.myHome.users; in
    lib.flatten (lib.mapAttrsToList (name: paths:
      lib.optionals (!builtins.elem name disabled) paths
    ) hmBundles);

in {
  imports = [ ./fonts.nix ];

  options.myHome.users = lib.mkOption {
    default     = {};
    description = "Per-user home-manager bundle configuration.";
    type = lib.types.attrsOf (lib.types.submodule {
      options.disabledBundles = lib.mkOption {
        type        = lib.types.listOf lib.types.str;
        default     = [];
        description = "Bundles to skip: shell, cli, dev, desktop, apps";
      };
    });
  };

  config = {
    home-manager.backupFileExtension = "backup";

    home-manager.users.matt = {
      imports = mkHmImports "matt" ++ [ ./base.nix ];

      home.stateVersion = "26.05";
    };
  };
}
