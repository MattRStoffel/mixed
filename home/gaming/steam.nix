{ config, lib, ... }:
lib.mkIf (!builtins.elem "gaming" (lib.attrByPath [ "matt" "disabledBundles" ] [] config.myHome.users)) {
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };
}
