{ config, lib, pkgs, ... }:
let
  tex = (pkgs.texlive.combine {
    inherit (pkgs.texlive) scheme-medium
      dvisvgm dvipng # for preview and export as html
      wrapfig amsmath ulem hyperref capt-of;
      #(setq org-latex-compiler "lualatex")
      #(setq org-preview-latex-default-process 'dvisvgm)
  });
in
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
      packages = with pkgs; [
        tex
      ];
    };
    programs = {
      kitty.enable = true;
      feh.enable = true;
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
