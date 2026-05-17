{ ... }: {
  # No native NixOS equivalent for the full linuxserver/calibre image (KasmVNC
  # GUI + content server), so this runs as a Docker container via NixOS.
  virtualisation.oci-containers = {
    backend = "docker";
    containers.calibre = {
      image = "lscr.io/linuxserver/calibre:latest";
      ports = [
        "1080:8080" # KasmVNC web GUI
        "1181:8181" # KasmVNC HTTPS
        "1081:8081" # Calibre content server
        "9090:9090" # Calibre wireless device sync
      ];
      environment = {
        PUID = "1000";
        PGID = "1000";
        TZ = "America/Los_Angeles";
        # Set CUSTOM_USER and PASSWORD here if you want to enable basic auth:
        # CUSTOM_USER = "matt";
        # PASSWORD = "your-password";
      };
      volumes = [
        "/home/matt/docker/calibre/config:/config"
        "/home/matt/media/books:/books"
      ];
    };
  };

  networking.firewall.allowedTCPPorts = [ 1080 1081 1181 9090 ];
}
