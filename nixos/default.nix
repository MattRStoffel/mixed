{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ../hardware-configuration.nix
    ./matt.nix
    ./nvidia.nix
  ];

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
      XCURSOR_SIZE = "32";
      HYPRCURSOR_SIZE = "32";
    };
    pathsToLink = ["/libexec"];
  };

  services.xserver = {
    enable = true;
    xkb.layout = "us";
    displayManager.gdm.enable = true;
    desktopManager.plasma5.enable = true;
    displayManager.defaultSession = "plasmawayland";
    windowManager.hypr.enable = true;
  };

  services.tailscale.enable = true;
  services.ollama.enable = true;

  home-manager.extraSpecialArgs = {inherit inputs;};

  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
    wireless.iwd.enable = true;
    networkmanager.wifi.backend = "iwd";
  };

  time.timeZone = "America/Los_Angeles";

  system.stateVersion = "24.11";
}
