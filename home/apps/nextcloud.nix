{ pkgs, lib, ... }:
{
  home.packages = lib.optionals pkgs.stdenv.isLinux [
    pkgs.nextcloud-client
  ];

  services.nextcloud-client = lib.mkIf pkgs.stdenv.isLinux {
    enable = true;
  };

  # Provides a secret service so Nextcloud client can persist credentials across reboots.
  services.gnome-keyring = lib.mkIf pkgs.stdenv.isLinux {
    enable = true;
    components = [ "secrets" ];
  };
}
