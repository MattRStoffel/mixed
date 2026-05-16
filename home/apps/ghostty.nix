{ lib, ... }:
let
  theme = import ../theme.nix;
  c = theme.colors;
in
{
  home.activation.reloadGhostty = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    pkill -USR2 ghostty 2>/dev/null || true
  '';

  programs.ghostty = {
    enable = true;
    settings = {
      font-size                  = theme.fonts.termSize;
      background                 = "#${c.background}";
      foreground                 = "#${c.text}";
      cursor-color               = "#${c.text}";
      selection-background       = "#${c.surface}";
      selection-foreground       = "#${c.text}";
      clipboard-read             = "allow";
      clipboard-paste-protection = false;
      palette = [
        "0=#${c.black}"
        "1=#${c.red}"
        "2=#${c.green}"
        "3=#${c.yellow}"
        "4=#${c.blue}"
        "5=#${c.magenta}"
        "6=#${c.cyan}"
        "7=#${c.white}"
        "8=#${c.brightBlack}"
        "9=#${c.brightRed}"
        "10=#${c.brightGreen}"
        "11=#${c.brightYellow}"
        "12=#${c.brightBlue}"
        "13=#${c.brightMagenta}"
        "14=#${c.brightCyan}"
        "15=#${c.brightWhite}"
      ];
    };
  };
}
