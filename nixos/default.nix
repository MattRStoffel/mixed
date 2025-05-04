{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  environment = {
    systemPackages = with pkgs; [
      neovim
    ];
    variables = {
      EDITOR = "nvim";
    };
    pathsToLink = ["/libexec"];
  };

  services.desktopManager.plasma6.enable = true;
  services.displayManager.defaultSession = "plasma";

  services.xserver = {
    enable = true;
    xkb.layout = "us";
    displayManager.gdm.enable = true;
  };

  system.stateVersion = "24.11";
}
