{ lib, config, ... }:
lib.mkIf (!builtins.elem "server" (lib.attrByPath [ "matt" "disabledBundles" ] [] config.myHome.users)) {
  services.jellyfin = {
    enable = true;
    # Run as matt so it can read media files without permission issues.
    user = "matt";
    group = "users";
    openFirewall = true;
  };

  # Media lives at /home/matt/media/{movies,tv,music,audio,books,youtube}
  # Point Jellyfin at those paths through the web UI after first boot.
}
