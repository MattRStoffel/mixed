{ lib, pkgs, ... }:

{
  fonts = {
    packages = with pkgs; [
      ibm-plex
      nerd-fonts.hack
      font-awesome
      noto-fonts
    ];
    fontDir.enable = lib.mkIf (!pkgs.stdenv.isDarwin) true;
  };
}
