{...}: {
  imports = [
    ./matt.nix
    ./network.nix
  ];
  nix.settings.experimental-features = ["nix-command" "flakes"];
  nixpkgs.config.allowUnfree = true;

  time.timeZone = "America/Los_Angeles";
}
