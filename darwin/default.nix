{...}: {
  imports = [
    ./system.nix
    ./homebrew.nix
  ];
  nix.settings.experimental-features = ["nix-command" "flakes"];
}
