{
  pkgs,
  ...
}: {
  imports = [
    ./home
  ];

  users.users.matt = {
    isNormalUser = true;
    extraGroups = ["wheel"];
    initialPassword = "poop";
    packages = with pkgs; [
      # legcord
      nextcloud-client
    ];
  };

  programs.steam = {
    enable = true;
    # remotePlay.openFirewall = true;
    # dedicatedServer.openFirewall = true;
    # localNetworkGameTransfers.openFirewall = true;
  };
}
