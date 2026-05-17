{ ... }: {
  services.jellyfin = {
    enable = true;
    # Run as matt so it can read media files without permission issues.
    user = "matt";
    group = "users";
    openFirewall = true;
  };

  # Media lives at /home/matt/media/{movies,tv,music,audio,books}
  # Point Jellyfin at those paths through the web UI after first boot.
}
