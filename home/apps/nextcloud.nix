{ pkgs, lib, ... }:
{
  home.packages = lib.optionals pkgs.stdenv.isLinux [
    pkgs.nextcloud-client
  ];

  services.nextcloud-client = lib.mkIf pkgs.stdenv.isLinux {
    enable = true;
  };
}
