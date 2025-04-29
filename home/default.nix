{...}: {
  imports = [
    ./direnv.nix
    ./fonts.nix
    ./git.nix
    ./nvim
    ./starship.nix
    ./steam.nix
    ./zoxide.nix
    ./zsh.nix
  ];

  users.users.matt = {
    name = "matt";
    home = "/Users/matt";
  };
  home-manager.users.matt = {
    home = {
      stateVersion = "24.11";
      shellAliases = {
        ":q" = "exit";
        "l" = "lsd";
        "ls" = "lsd";
        "la" = "lsd -a";
        "ll" = "lsd -l";
        "lt" = "lsd --tree";
        "lla" = "lsd -la";
        "lltt" = "lsd -l --tree";
        "llt" = "lsd -l --tree --depth 2";
        "llatt" = "lsd -la --tree";
        "llat" = "lsd -la --tree --depth 2";
        "top" = "btop";
        "htop" = "btop";
        "cat" = "bat";
        "dog" = "bat";
        "benji" = "dog";
        "build" = "zig build -Dtarget=aarch64-linux-musl";
      };
    };
    programs = {
      bat.enable = true;
      lsd.enable = true;
      fzf.enable = true;
      fd.enable = true;
      ripgrep.enable = true;
      fastlane.enable = true;
      btop.enable = true;
    };
  };
}
