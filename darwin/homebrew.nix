{self, ...}: {
  homebrew = {
    enable = true;

    casks = [
      "alfred"
      "discord"
      "ghostty"
      "mac-mouse-fix"
      "nextcloud"
      "obsidian"
      "rectangle"
      "tailscale"
      "google-chrome"
      "steam"
    ];
    masApps = {
      Xcode = 497799835;
      wipr-2 = 1662217862;
    };
  };
}
