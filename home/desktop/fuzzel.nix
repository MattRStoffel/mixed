{...}: {
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        font         = "Cartograph CF Nerd Font:size=13";
        prompt       = "'❯  '";
        terminal     = "ghostty";
        width        = 40;
        horizontal-pad = 20;
        vertical-pad   = 15;
        inner-pad      = 10;
        line-height    = 25;
      };

      colors = {
        background      = "191724ff";
        text            = "e0def4ff";
        match           = "f6c177ff";
        selection       = "26233aff";
        selection-text  = "9ccfd8ff";
        selection-match = "f6c177ff";
        border          = "9ccfd833";
      };

      border = {
        width  = 1;
        radius = 4;
      };
    };
  };
}
