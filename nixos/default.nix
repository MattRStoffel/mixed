{ ... }: {
  imports = [
    ./hardware-configuration.nix
    ./macbook
    ./boot.nix
    ./display.nix
    ./networking.nix
  ];

  security.polkit.enable = true;        # system-wide privilege escalation daemon
  environment.pathsToLink = [ "/libexec" ]; # needed by GTK/D-Bus helpers

  system.stateVersion = "24.11";
}
