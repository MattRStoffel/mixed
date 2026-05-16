{pkgs, ...}: {
  imports = [ ./colors.nix ];
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

  xdg.configFile."nvim".source = ./config;
}
