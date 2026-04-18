{ ... }: {
  imports = [
    ./hardware-configuration.nix
    ./macbook
    ./boot.nix
    ./display.nix
    ./networking.nix
  ];

  security.polkit.enable = true;        # system-wide privilege escalation daemon
  environment.pathsToLink = [ "/libexec" ]; # needed by GTK/D-Bus helpers
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  };
  system.stateVersion = "24.11";
}
