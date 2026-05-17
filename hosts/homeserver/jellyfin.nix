{ ... }: {
  services.jellyfin = {
    enable = true;
    user = "matt";
    group = "users";
    openFirewall = true;
  };
}
