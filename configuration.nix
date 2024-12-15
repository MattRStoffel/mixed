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

  environment.systemPackages = with pkgs; [
    neovim
    tailscale
  ];
  environment.variables.EDITOR = "neovim";
  environment.pathsToLink = ["/libexec"];

  services.xserver = {
    enable = true;
    xkb.layout = "us";
    displayManager = {
      gdm.enable = true;
      sessionCommands = ''
        ${pkgs.xorg.xrdb}/bin/xrdb -merge <<EOF
        Xft.dpi: 192
        EOF
      '';
    };
    # desktopManager.plasma5.enable = true;
    # desktopManager.gnome.enable = true;
    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
	networkmanager
	dmenu
        i3status
        i3lock
        i3blocks
        brightnessctl
	pulseaudio 
	arandr # For adjusting screen layout
	autorandr # Auto Activate screens
	feh # For setting wallpaper
      ];
    };
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
  networking.wireless.iwd.enable = true;
  networking.networkmanager.wifi.backend = "iwd";

  time.timeZone = "America/Los_Angeles";

  services.tailscale.enable = true;

  system.stateVersion = "24.11";
}
