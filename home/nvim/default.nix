{ config, lib, pkgs, ... }:

{
  home-manager.users.matt = {
    programs.neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;

      plugins = with pkgs.vimPlugins; [
	{
	  plugin = comment-nvim;
	  type = "lua";
	  config = "require(\"Comment\").setup()";
	}
	{
          plugin = conform-nvim;
	  type = "lua";
	  config = builtins.readFile ./plugin/conform.lua;
	}
	{
          plugin = dracula-nvim;
	  config = "colorscheme dracula";
	}
        neo-tree-nvim
	{
          plugin = nvim-cmp;
	  type = "lua";
	  config = builtins.readFile ./plugin/cmp.lua;
	}
        nvim-lint
        nvim-lspconfig
        (nvim-treesitter.withPlugins (p: [
          p.tree-sitter-nix
          p.tree-sitter-vim
          p.tree-sitter-bash
          p.tree-sitter-lua
          p.tree-sitter-python
          p.tree-sitter-json
        ]))
        nvim-treesitter-textobjects
	{
          plugin = lualine-nvim;
	  type = "lua";
	  config = builtins.readFile ./plugin/lualine.lua;
	}
	{
          plugin = noice-nvim;
	  type = "lua";
	  config = builtins.readFile ./plugin/noice.lua;
	}
        persistence-nvim
        telescope-nvim
        which-key-nvim
      ];
    };
  };
}
