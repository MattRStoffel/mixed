{ config, lib, ... }:

let
  # Get the hostname from the flake reference
  hostname = builtins.head (lib.splitString "." config.system);
in {
  networking = {
    computerName = hostname;
    hostName = hostname;
    localHostName = hostname;
	};

}
