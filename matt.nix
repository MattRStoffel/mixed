{ config, lib, pkgs, ... }:

{
  home-manager.users.matt = {
    programs.bash.enable = true;
    home = {
      shellAliases = {
        ":q" = "exit";
        hello = "echo hello";
        vim = "nvim";
        vi = "nvim";
      };
      stateVersion = "24.11";
    };
    programs = {
      neovim.enable = true;
      firefox.enable = true;
      fzf.enable = true;
      fd.enable = true;
      starship.enable = true;
      git = {
        enable = true;
      };
      zoxide = {
        enable = true;
        enableBashIntegration = true;
      };
    };
  };

  users.users.matt = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    initialPassword = "poop";
    packages = with pkgs; [
      legcord
      nextcloud-client
    ];
  };
  
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };
} 
