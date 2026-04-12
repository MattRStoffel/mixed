# =============================================================================
# nixos/networking.nix — Network stack.
#
# Hostname and iwd backend are set in shared/network.nix.
# This file handles the NixOS-specific extras: power management,
# nm-applet system tray widget, and the networkmanager user group.
# =============================================================================
{ lib, ... }: {
  networking = {
    hostName                      = "nixos";
    networkmanager.enable         = true;
    networkmanager.wifi.backend   = "iwd";
    networkmanager.wifi.powersave = false;
    useDHCP                       = lib.mkDefault true;
    wireless.iwd.enable           = true;
  };

  # nm-applet provides the system-tray Wi-Fi / VPN widget inside Sway
  programs.nm-applet.enable = true;

  # matt needs to be in networkmanager to manage connections without sudo
  users.users.matt.extraGroups = [ "networkmanager" ];

}
