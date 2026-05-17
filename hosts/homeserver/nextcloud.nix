{ pkgs, ... }: {
  services.nextcloud = {
    enable = true;

    # Set this to the hostname or IP you'll use to access Nextcloud.
    # e.g. "192.168.1.50" or "nextcloud.home"
    hostName = "localhost";

    # Match this to whatever version your existing Docker install was running.
    # Check with: docker exec nextcloud_app php occ status
    package = pkgs.nextcloud30;

    # Keep data on the dedicated Nextcloud drive, matching the Ansible layout.
    datadir = "/home/matt/nextcloud/app";

    # Use MySQL (MariaDB-compatible) to stay consistent with the Ansible setup.
    database.createLocally = true;
    config = {
      dbtype = "mysql";

      # Create this file before switching:
      #   echo -n "your-admin-password" | sudo tee /etc/nextcloud-adminpass
      #   sudo chmod 600 /etc/nextcloud-adminpass
      adminpassFile = "/etc/nextcloud-adminpass";
    };
  };

  # If you have existing Docker Nextcloud data, you'll need to import the
  # MariaDB dump from the old container before starting this service:
  #   docker exec nextcloud_db mysqldump -u nextcloud -p nextcloud > /tmp/nextcloud.sql
  # Then after switching, import it into the new MySQL instance.

  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
