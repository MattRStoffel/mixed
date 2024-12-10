{
  pkgs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./mixer.nix
    ./matt.nix
  ];

  nix.settings.experimental-features = ["nix-command" "flakes"];

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

  environment.pathsToLink = ["/libexec"];

  services.xserver = {
    enable = true;
    displayManager = {
      sessionCommands = ''
        ${pkgs.xorg.xrdb}/bin/xrdb -merge <<EOF
        Xft.dpi: 192
        EOF
      '';
    };
    windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
      extraPackages = with pkgs; [
        dmenu
        i3status
        i3lock
        i3blocks
        brightnessctl
      ];
    };
  };

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  services.displayManager.defaultSession = "none+i3";

  # Configure keymap in X11
  services.xserver.xkb.layout = "us";
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos";

  time.timeZone = "America/Los_Angeles";

  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    vim
    tailscale
  ];

  services.tailscale.enable = true;

  system.stateVersion = "24.11";
}
