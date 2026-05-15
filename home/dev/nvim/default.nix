{pkgs, ...}: {
  programs.neovim = {
    enable        = true;
    defaultEditor = true;
    viAlias       = true;
    vimAlias      = true;
    vimdiffAlias  = true;
  };

  # Symlink config files into ~/.config/nvim/ so the layout is standard and
  # portable — on a non-NixOS machine just copy the same files there directly.
  xdg.configFile = {
    "nvim/init.lua".source                      = ./init.lua;
    "nvim/lua/options.lua".source               = ./lua/options.lua;
    "nvim/lua/plugins.lua".source               = ./lua/plugins.lua;
    "nvim/lua/keymaps.lua".source               = ./lua/keymaps.lua;
    "nvim/lua/theme.lua".source                 = ./lua/theme.lua;
    "nvim/lua/plugins/telescope.lua".source     = ./lua/plugins/telescope.lua;
    "nvim/lua/plugins/treesitter.lua".source    = ./lua/plugins/treesitter.lua;
    "nvim/lua/plugins/lsp.lua".source           = ./lua/plugins/lsp.lua;
    "nvim/lua/plugins/completion.lua".source    = ./lua/plugins/completion.lua;
  };
}
