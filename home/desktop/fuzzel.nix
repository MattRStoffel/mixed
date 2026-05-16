{ ... }:
let
  theme = import ../theme.nix;
  c = theme.colors;
  f = theme.fonts;
in
{
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        font         = "${f.ui}:size=${toString f.size}";
        prompt       = "'❯  '";
        terminal     = "ghostty";
        width        = 40;
        horizontal-pad = 20;
        vertical-pad   = 15;
        inner-pad      = 10;
        line-height    = 25;
      };

      colors = {
        background      = "${c.background}ff";
        text            = "${c.text}ff";
        match           = "${c.highlight}ff";
        selection       = "${c.surface}ff";
        selection-text  = "${c.accent}ff";
        selection-match = "${c.highlight}ff";
        border          = "${c.accent}33";
      };

      border = {
        width  = 1;
        radius = 4;
      };
    };
  };
}
