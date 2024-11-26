{ config, lib, pkgs, ... }:

{
  imports = 
  [
    ./fonts.nix
    ./nextcloud.nix
    ./nvim
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
}
