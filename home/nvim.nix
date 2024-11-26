{ config, lib, pkgs, ... }:

{
  home-manager.users.matt = {
    programs = {
      neovim = {
        enable = true;
        
	viAlias = true;
	vimAlias = true;
	vimdiffAlias = true;

	plugins = with pkgs.vimPlugins; [
	  conform-nvim
	  dracula-nvim
	  neo-tree-nvim
	  nvim-lint
	  nvim-treesitter
	  nvim-treesitter-textobjects
	  lualine-nvim
	  noice-nvim
	  persistence-nvim
	  telescope-nvim
	  tokyonight-nvim
	  which-key-nvim
	];
      };
    };
  };
}
