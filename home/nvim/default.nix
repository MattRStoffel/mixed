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
	nvim-cmp
	nvim-web-devicons
	vimtex
        which-key-nvim
	{
	  plugin = conform-nvim;
	  type = "lua";
	  config = builtins.readFile ./plugins/conform.lua;
	}

	# LSP
	{
	  plugin = mason-nvim;
	  type = "lua";
	  config = "require(\"mason\").setup()";
	}
	{
	  plugin = nvim-lspconfig;
	  type = "lua";
	  config = builtins.readFile ./plugins/lspconfig.lua;
	}

	# UI
	{
	  plugin = telescope-nvim;
	  type = "lua";
	  config = builtins.readFile ./plugins/telescope.lua;
	}
	{
          plugin = neo-tree-nvim;
	  type = "lua";
	  config = builtins.readFile ./plugins/neo-tree.lua;
	}

	# UX
	{
          plugin = dracula-nvim;
	  type = "lua";
	  config = "vim.cmd.colorscheme 'dracula'";
	}
	{
	  plugin = lualine-nvim;
	  type = "lua";
	  config = builtins.readFile ./plugins/lualine.lua;
	}
	{
          plugin = noice-nvim;
	  type = "lua";
	  config = builtins.readFile ./plugins/noice.lua;
	}
      ];
    };
  };
}
