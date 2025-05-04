{self, ...}: {
  imports = [
    ./homebrew.nix
    ./power.nix
  ];
  system = {
    configurationRevision = self.rev or self.dirtyRev or null;
    stateVersion = 5;

    defaults = {
      NSGlobalDomain = {
        InitialKeyRepeat = 12;
        KeyRepeat = 3;
        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticDashSubstitutionEnabled = false;
        NSAutomaticInlinePredictionEnabled = false;
        NSAutomaticPeriodSubstitutionEnabled = false;
        NSAutomaticQuoteSubstitutionEnabled = false;
        NSAutomaticSpellingCorrectionEnabled = false;
        NSAutomaticWindowAnimationsEnabled = false;
        NSNavPanelExpandedStateForSaveMode = true;
        NSTableViewDefaultSizeMode = 2;
      };

      WindowManager.EnableStandardClickToShowDesktop = false;

      dock = {
        autohide = true;
        autohide-delay = 0.0;
        autohide-time-modifier = 0.0;
        persistent-apps = [];
        persistent-others = [];
        show-process-indicators = false;
        orientation = "left";
        show-recents = false;
        tilesize = 45;
        wvous-bl-corner = 1;
        wvous-br-corner = 1;
        wvous-tl-corner = 1;
        wvous-tr-corner = 1;
      };

      finder = {
        AppleShowAllExtensions = true;
        FXEnableExtensionChangeWarning = false;
        FXPreferredViewStyle = "clmv";
        NewWindowTarget = "Home";
        ShowPathbar = true;
        ShowRemovableMediaOnDesktop = false;
      };

      loginwindow = {
        DisableConsoleAccess = true;
        GuestEnabled = false;
        SHOWFULLNAME = true;
        autoLoginUser = "matt";
      };

      screencapture = {
        disable-shadow = true;
        location = "~/Downloads";
      };
    };
  };
}
