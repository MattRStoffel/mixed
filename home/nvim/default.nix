{pkgs, ...}: {
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
  };
  home.file = {
    ".config/nvim/init.lua".text = builtins.readFile ./init.lua;
  };
}
