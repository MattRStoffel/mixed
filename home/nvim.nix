{ config, lib, pkgs, ... }:

{
  home-manager.users.matt = {
    programs.neovim = 
    let
      toLua = str: "lua << EOF\n${str}\nEOF\n";
      toLuaFile = file: "lua << EOF\n${builtins.readFile file}\nEOF\n";
    in
    {
      enable = true;
      
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;

      plugins = with pkgs.vimPlugins; [
	{
	  plugin = comment-nvim;
	  config = toLua "require(\"Comment\").setup()";
	}
	{
          plugin = conform-nvim;
	  config = toLuaFile ./nvim/plugin/conform.lua;
	}
	{
          plugin = dracula-nvim;
	  config = "colorscheme dracula";
	}
        neo-tree-nvim
        nvim-cmp
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
        lualine-nvim
	{
          plugin = noice-nvim;
	  config = toLuaFile ./nvim/plugin/noice.lua;
	}
        persistence-nvim
        telescope-nvim
        tokyonight-nvim
        which-key-nvim
      ];
    };
  };
}
