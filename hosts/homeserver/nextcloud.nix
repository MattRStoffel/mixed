{ pkgs, ... }: {
  services.nextcloud = {
    enable = true;
    hostName = "matt.lab";
    package = pkgs.nextcloud31;
    datadir = "/home/matt/nextcloud/app";
    configureRedis = true;
    database.createLocally = true;
    config = {
      dbtype = "mysql";
      # Create this file before switching:
      #   echo -n "your-admin-password" | sudo tee /etc/nextcloud-adminpass
      #   sudo chmod 600 /etc/nextcloud-adminpass
      adminpassFile = "/etc/nextcloud-adminpass";
    };
  };

  # If you have existing Docker Nextcloud data, import the MariaDB dump before switching:
  #   docker exec nextcloud_db mysqldump -u nextcloud -p nextcloud > /tmp/nextcloud.sql
  # Then import it into the new MySQL instance after switching.

  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
