{ ... }: {
  virtualisation.oci-containers = {
    backend = "docker";
    containers.metube = {
      image = "ghcr.io/alexta69/metube";
      ports = [ "9999:8081" ];
      volumes = [ "/home/matt/data/downloads:/downloads" ];
    };
  };

  networking.firewall.allowedTCPPorts = [ 9999 ];
}
