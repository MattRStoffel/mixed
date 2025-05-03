{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
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

  system.stateVersion = "24.11";
}
