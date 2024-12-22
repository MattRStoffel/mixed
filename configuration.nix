{
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./mixer.nix
    ./matt.nix
    ./nvidia.nix
  ];

  nix.settings.experimental-features = ["nix-command" "flakes"];
  nixpkgs.config.allowUnfree = true;

  # Make the macbook-pro work
  hardware.firmware = [
    (pkgs.stdenvNoCC.mkDerivation (final: {
      name = "brcm-firmware";
      src = ./firmware/brcm;
      installPhase = ''
        mkdir -p $out/lib/firmware/brcm
        cp ${final.src}/* "$out/lib/firmware/brcm"
      '';
    }))
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  environment = {
    systemPackages = with pkgs; [
      neovim
      tailscale
    ];
    variables = {
      EDITOR = "nvim";
    };
    pathsToLink = ["/libexec"];
  };

  services.xserver = {
    enable = true;
    xkb.layout = "us";
    displayManager.gdm.enable = true;
    # desktopManager.plasma5.enable = true;
    desktopManager.gnome.enable = true;
    windowManager.i3.enable = true;
  };

  services.tailscale.enable = true;

  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
    wireless.iwd.enable = true;
    networkmanager.wifi.backend = "iwd";
  };

  time.timeZone = "America/Los_Angeles";

  system.stateVersion = "24.11";
}
