{pkgs, ...}: {
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    extraLuaConfig = ''
      ${builtins.readFile ./init.lua}
      ${builtins.readFile ./plugins/stab.lua}
    '';

    plugins = with pkgs.vimPlugins; [
      # LSP & Completions
      {
        plugin = nvim-lspconfig;
        type = "lua";
        config = builtins.readFile ./plugins/lspconfig.lua;
      }
      {
        plugin = nvim-cmp;
        type = "lua";
        config = builtins.readFile ./plugins/cmp.lua;
      }
      cmp-nvim-lsp
      cmp-path

      # Formatting
      {
        plugin = conform-nvim;
        type = "lua";
        config = builtins.readFile ./plugins/conform.lua;
      }

      # Editor
      comment-nvim
      nvim-web-devicons
      which-key-nvim

      {
        plugin = oil-nvim;
        type = "lua";
        config = "require('oil').setup()";
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
    ];

    # All the language servers
    extraPackages = with pkgs; [
      nodejs
      nodePackages.typescript-language-server

      # Swift
      sourcekit-lsp

      # Lua
      vimPlugins.luasnip
      lua-language-server
      luajitPackages.lua-lsp
      stylua

      # Nix
      nil
      alejandra

      # C, C++
      clang-tools
      ccls
      cppcheck

      # Shell scripting
      shfmt
      shellcheck

      # Go
      go
      gopls
      golangci-lint

      # Python
      pyright

      # Astro
      astro-language-server

      # Telescope dependencies
      ripgrep
      fd
    ];
  };
}
