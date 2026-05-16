{ ... }: {
  imports = [
    ./hardware-configuration.nix
    ./t2
    ../../nixos
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
