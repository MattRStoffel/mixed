{
  config,
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
  environment.variables.EDITOR = "nvim";
  environment.pathsToLink = ["/libexec"];
  # Enable OpenGL
  # hardware.opengl = {
  #   enable = true;
  #   driSupport = true;
  #   driSupport32Bit = true;
  # };

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    powerManagement.enable = false;
    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of
    # supported GPUs is at:
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
    # Only available from driver 515.43.04+
    # Currently alpha-quality/buggy, so false is currently the recommended setting.
    open = false;

    # Enable the Nvidia settings menu,
    # accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    # Use Nvidia Prime to choose which GPU (iGPU or eGPU) to use.
    prime = {
        sync.enable = false;
        allowExternalGpu = true;

        # Make sure to use the correct Bus ID values for your system!
        nvidiaBusId = "PCI:127:0:0";
        intelBusId = "PCI:0:2:0";
    };
  };

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
    desktopManager.gnome.enable = true;
    windowManager.i3.enable = true;
	#      enable = true;
	#      extraPackages = with pkgs; [
	#        networkmanager
	#        dmenu
	#        i3status
	#        i3lock
	#        i3blocks
	#        brightnessctl
	#        pulseaudio 
	#        arandr # For adjusting screen layout
	#        autorandr # Auto Activate screens
	#        feh # For setting wallpaper
	#      ];
	#    };
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
