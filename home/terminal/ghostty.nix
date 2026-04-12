{...}: {
  home-manager.users.matt.home.file.".config/ghostty/config".text = ''
       theme = "Dracula"
       font-size = 10

       clipboard-read = "allow"
       clipboard-paste-protection = false
  '';
}
