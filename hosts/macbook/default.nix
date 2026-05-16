{ ... }: {
  imports = [
    ./boot.nix
    ./display.nix
    ./hardware-configuration.nix
    ./networking.nix
    ./t2
  ];

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };

  virtualisation.docker.enable = true;
  users.users.matt.extraGroups = [ "docker" ];

  # myHome.users.matt.disabledBundles = [ "server" ];

  system.stateVersion = "24.11";
}
