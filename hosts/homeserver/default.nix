# Placeholder — add hardware-configuration.nix before building:
#   sudo nixos-generate-config --show-hardware-config > hosts/homeserver/hardware-configuration.nix
{ ... }: {
  imports = [
    # ./hardware-configuration.nix
    ./calibre.nix
    ./jellyfin.nix
    ./metube.nix
    ./nextcloud.nix
  ];

  virtualisation.docker.enable = true;
  users.users.matt.extraGroups = [ "docker" ];

  fileSystems."/home/matt/media" = {
    device = "/dev/disk/by-uuid/ffc30921-a43b-45b2-b29c-80c1d786f554";
    fsType = "ext4";
    options = [ "noatime" ];
  };

  fileSystems."/home/matt/nextcloud" = {
    device = "/dev/disk/by-uuid/3f77516a-1a4f-4d90-af61-4b0d5e24aad0";
    fsType = "ext4";
    options = [ "noatime" ];
  };

  fileSystems."/home/matt/data" = {
    device = "/dev/disk/by-uuid/987e2748-a7e7-4924-8568-bae9aaa45175";
    fsType = "ext4";
    options = [ "noatime" ];
  };

  fileSystems."/home/matt/docker" = {
    device = "/dev/disk/by-uuid/dacce5ab-70ce-4c5f-9b3c-af0b53a837cb";
    fsType = "ext4";
    options = [ "noatime" ];
  };

  system.stateVersion = "24.11";

  myHome.users.matt.disabledBundles = [ "desktop" "apps" "games" ];
}
