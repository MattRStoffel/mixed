{ ... }:
let
  theme = import ../../theme.nix;
  c     = theme.colors;
  f     = theme.fonts;
in {
  xdg.configFile."nvim/lua/config/colors.lua".text = ''
    return {
      colors = {
        background    = "#${c.background}",
        surface       = "#${c.surface}",
        text          = "#${c.text}",
        subtle        = "#${c.subtle}",
        accent        = "#${c.accent}",
        secondary     = "#${c.secondary}",
        highlight     = "#${c.highlight}",
        urgent        = "#${c.urgent}",
        black         = "#${c.black}",
        red           = "#${c.red}",
        green         = "#${c.green}",
        yellow        = "#${c.yellow}",
        blue          = "#${c.blue}",
        magenta       = "#${c.magenta}",
        cyan          = "#${c.cyan}",
        white         = "#${c.white}",
        brightBlack   = "#${c.brightBlack}",
        brightRed     = "#${c.brightRed}",
        brightGreen   = "#${c.brightGreen}",
        brightYellow  = "#${c.brightYellow}",
        brightBlue    = "#${c.brightBlue}",
        brightMagenta = "#${c.brightMagenta}",
        brightCyan    = "#${c.brightCyan}",
        brightWhite   = "#${c.brightWhite}",
      },
      fonts = {
        mono     = "${f.mono}",
        size     = ${toString f.size},
        termSize = ${toString f.termSize},
      },
    }
  '';
}
