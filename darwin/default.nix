{self, ...}: {
  imports = [
    ./ns.nix
    ./dock.nix
    ./finder.nix
    ./homebrew.nix
    ./login.nix
    ./power.nix
    ./screenshot.nix
    ./windowmanager.nix
  ];
  system = {
    configurationRevision = self.rev or self.dirtyRev or null;
    stateVersion = 5;
  };
}
