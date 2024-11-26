{ config, lib, pkgs, ... }:

{
  imports = [
    ./home/nvim
    ./home/nextcloud.nix
    ./home/fonts.nix
  ];
  home-manager.users.matt = {
    home = {
      shellAliases = {
        ":q" = "exit";
        hello = "echo hello";
	nrs = "sudo nixos-rebuild switch --flake .";
      };
      stateVersion = "24.11";
    };
    programs = {
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
