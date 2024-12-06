{ config, lib, pkgs, ... }:

let
  fromGitHub = ref: repo: pkgs.vimUtils.buildVimPlugin {
    pname = "${lib.strings.sanitizeDerivationName repo}";
    version = ref;
    src = builtins.fetchGit {
      url = "https://github.com/${repo}.git";
      ref = ref;
    };
  };
in

{
  home-manager.users.matt = {
    programs.neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;

      extraLuaConfig = builtins.readFile ./init.lua;

      plugins = with pkgs.vimPlugins; [
	comment-nvim
	{
          plugin = conform-nvim;
	  type = "lua";
	  config = builtins.readFile ./plugins/conform.lua;
	}
	{
          plugin = dracula-nvim;
	  type = "lua";
	  config = "vim.cmd.colorscheme 'dracula'";
	}
	mini-nvim
	{
          plugin = neo-tree-nvim;
	  type = "lua";
	  config = builtins.readFile ./plugins/neo-tree.lua;
	}
        nvim-cmp
        nvim-lint
        nvim-lspconfig
	{
	  plugin = lualine-nvim;
	  type = "lua";
	  config = builtins.readFile ./plugins/lualine.lua;
	}
	nvim-web-devicons
	{
          plugin = noice-nvim;
	  type = "lua";
	  config = builtins.readFile ./plugins/noice.lua;
	}
        persistence-nvim
	{
	  plugin = telescope-nvim;
	  type = "lua";
	  config = builtins.readFile ./plugins/telescope.lua;
	}
	vimtex
        which-key-nvim
      ];
    };
  };
}
