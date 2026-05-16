{ lib, pkgs, ... }:

{
  fonts = {
    packages = with pkgs; [
      ibm-plex
      nerd-fonts.hack
      nerd-fonts.jetbrains-mono
      font-awesome
      noto-fonts
    ];
    fontDir.enable = lib.mkIf (!pkgs.stdenv.isDarwin) true;
  };
}
