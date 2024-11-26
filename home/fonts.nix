{ lib, pkgs, ... }:

{
  fonts = {
    packages = with pkgs; [
      ibm-plex
      (nerdfonts.override {fonts = ["Hack"];})
      font-awesome
      noto-fonts
    ];
    fontDir.enable = lib.mkIf (!pkgs.stdenv.isDarwin) true;
  };
}
