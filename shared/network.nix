{pkgs, ...}: {
  networking =
    if pkgs.stdenv.isDarwin
    then {
      computerName = "macbook";
      hostName = "macbook";
      localHostName = "macbook";
    }
    else {
      hostName = "nixos";
      networkmanager.enable = true;
      wireless.iwd.enable = true;
      networkmanager.wifi.backend = "iwd";
    };
}
