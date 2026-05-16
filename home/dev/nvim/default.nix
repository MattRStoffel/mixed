{pkgs, ...}: {
  programs.neovim = {
    enable        = true;
    defaultEditor = true;
    viAlias       = true;
    vimAlias      = true;
    vimdiffAlias  = true;
    extraPackages = with pkgs; [
      nodejs
      gcc
      clang
      unzip
      go
      haskell-language-server
    ];
  };

  xdg.configFile = {
    "nvim/init.lua".source                   = ./init.lua;
    "nvim/lua/config/options.lua".source     = ./lua/config/options.lua;
    "nvim/lua/config/keymaps.lua".source     = ./lua/config/keymaps.lua;
    "nvim/lua/plugins/telescope.lua".source  = ./lua/plugins/telescope.lua;
    "nvim/lua/plugins/lsp.lua".source        = ./lua/plugins/lsp.lua;
    "nvim/lua/plugins/completion.lua".source  = ./lua/plugins/completion.lua;
    "nvim/lua/plugins/colorizer.lua".source   = ./lua/plugins/colorizer.lua;
    "nvim/lua/plugins/treesitter.lua".source = ./lua/plugins/treesitter.lua;
  };
}
