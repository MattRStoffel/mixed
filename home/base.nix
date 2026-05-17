{ ... }: {
  home.sessionVariables = {
    XDG_CONFIG_HOME = "$HOME/.config";
    EDITOR          = "nvim";
    TERM            = "ghostty";
  };
  home.shellAliases = {
    ":q"    = "exit";
    "htop"  = "btop";
    "cat"   = "bat";
    "dog"   = "bat";
    "benji" = "dog";
  };
}
