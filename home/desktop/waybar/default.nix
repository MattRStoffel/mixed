{ pkgs, ... }:
{
  programs.waybar = {
    enable   = true;
    settings = import ./modules.nix { inherit pkgs; };
    style    = import ./style.nix;
  };

  home.packages = with pkgs; [ pavucontrol ];
}
