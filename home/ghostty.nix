{...}: {
  programs.ghostty = {
    enable = true;
    settings = {
      window-height = 45;
      window-width = 120;

      theme = "Dracula";
      font-size = 14;

      clipboard-read = "allow";
      clipboard-paste-protection = false;

      keybind = "global:cmd+grave_accent=toggle_quick_terminal";
    };
  };
}
