{pkgs, ...}: {
  home-manager.users.matt = {
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
        {
          plugin = noice-nvim;
          type = "lua";
          config = builtins.readFile ./plugins/noice.lua;
        }

        # Copilot
        {
          plugin = copilot-lua;
          type = "lua";
          config = builtins.readFile ./plugins/copilot.lua;
        }
        CopilotChat-nvim
        plenary-nvim # for CopilotChat-nvim
        copilot-lualine

        # Misc
        vimtex
      ];

      # All the language servers
      extraPackages = with pkgs; [
        # nodejs
        # nodePackages.typescript-language-server
        #
        # # Swift
        # sourcekit-lsp
        #
        # # Lua
        # luajitPackages.lua-lsp
        # stylua
        #
        # # Nix
        # nil
        # alejandra
        #
        # # C, C++
        # clang-tools
        # ccls
        # cppcheck
        # bear
        #
        # # Shell scripting
        # shfmt
        # shellcheck
        #
        # # Go
        # go
        # gopls
        # golangci-lint
        # delve
        #
        # # GLSL
        # glsl_analyzer
        #
        # # Haskell
        # hlint
        # stylish-haskell
        #
        # # Astro
        # astro-language-server
        #
        # # Additional
        # texliveMedium
        # texlab
        # codespell
        # gitlint

        # Telescope dependencies
        ripgrep
        fd
      ];
    };
  };
}
