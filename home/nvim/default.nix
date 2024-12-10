{ lib, pkgs, ... }:

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
	# LSP
	{
	  plugin = nvim-lspconfig;
	  type = "lua";
	  config = builtins.readFile ./plugins/lspconfig.lua;
	}

	# Completions
	{
	  plugin = nvim-cmp;
	  type = "lua";
	  config = builtins.readFile ./plugins/cmp.lua;
	}
	cmp-nvim-lsp
	cmp-buffer
	cmp-path
	cmp_luasnip
	luasnip

	comment-nvim

	# Formatting
	{
	  plugin = conform-nvim;
	  type = "lua";
	  config = builtins.readFile ./plugins/conform.lua;
	}

	# Editor
        which-key-nvim
	nvim-web-devicons
	{
          plugin = neo-tree-nvim;
	  type = "lua";
	  config = builtins.readFile ./plugins/neo-tree.lua;
	}
	{
	  plugin = telescope-nvim;
	  type = "lua";
	  config = builtins.readFile ./plugins/telescope.lua;
	}
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

	# Misc
	vimtex
      ];

      # All the language servers
      extraPackages = with pkgs; [
        # Python
        pyright
  
        # Lua
	luajitPackages.lua-lsp
  
        # Nix
        nil
  
        # C, C++
        clang-tools
        cppcheck
  
        # Shell scripting
        shfmt
        shellcheck
  
        # Go
        go
        gopls
        golangci-lint
        delve
  
        # Additional
	texliveMedium
        texlab
        codespell
        gitlint
  
        # Telescope dependencies
        ripgrep
        fd
      ];
    };
  };
}
