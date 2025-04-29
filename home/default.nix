{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./fonts.nix
    # ./nextcloud.nix
    ./nvim
    # ./kitty.nix
    # ./i3.nix
    ./zsh.nix
  ];

  environment.systemPackages = [
    pkgs.entr
  ];
  users.users.matt = {
    name = "matt";
    home = "/Users/matt";
  };

  # programs.steam = {
  #   enable = true;
  #   dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  #   localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  # };
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
        "cat" = "bat";
        "dog" = "bat";
        "benji" = "dog";
        "build" = "zig build -Dtarget=aarch64-linux-musl";
      };

      # packages = [
      #   pkgs.zoom-us
      #   pkgs.legcord
      #   pkgs.nextcloud-client
      #   pkgs.unzip
      #   pkgs.vlc
      #   pkgs.libreoffice
      #   inputs.ghostty.packages."${pkgs.system}".default
      # ];
    };
    programs = {
      bat.enable = true;
      direnv = {
        enable = true;
        enableBashIntegration = true;
        enableZshIntegration = true;
        nix-direnv.enable = true;
        config.hide_env_diff = true;
      };
      lsd.enable = true;
      fzf.enable = true;
      fd.enable = true;
      ripgrep.enable = true;
      starship = {
        enable = true;
        enableBashIntegration = true;
        enableZshIntegration = true;
      };
      htop.enable = true;
      fastlane.enable = true;
      bottom.enable = true;
      btop.enable = true;
      git = {
        enable = true;
        userName = "MattRStoffel";
        userEmail = "Matt@MrStoffel.com";
      };
      zoxide = {
        enable = true;
        enableBashIntegration = true;
        enableZshIntegration = true;
      };
    };
  };
}
