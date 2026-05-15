{...}: {
  programs.ghostty = {
    enable = true;
    settings = {
      theme = "Dracula";
      font-size = 10;
      clipboard-read = "allow";
      clipboard-paste-protection = false;
    };
  };
}
