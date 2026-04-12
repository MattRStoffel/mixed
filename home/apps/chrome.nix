{...}: {
  nixpkgs.config.allowUnfree = true;
  programs.google-chrome.enable = true;
}
