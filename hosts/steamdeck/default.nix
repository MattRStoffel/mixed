# Placeholder — add hardware-configuration.nix before building:
#   sudo nixos-generate-config --show-hardware-config > hosts/steamdeck/hardware-configuration.nix
{ ... }: {
  imports = [
    # ./hardware-configuration.nix
  ];

  # Base steam comes from home/gaming/; gamescopeSession is deck-specific.
  programs.steam.gamescopeSession.enable = true;

  hardware.bluetooth.enable = true;

  system.stateVersion = "24.11";

  # myHome.users.matt.disabledBundles = [ "server" ];
}
