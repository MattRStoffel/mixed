{ pkgs, ... }:
let
  c = (import ../theme.nix).colors;
in
{
  programs.fzf = {
    enable = true;
    colors = {
      bg        = "#${c.background}";
      "bg+"     = "#${c.surface}";
      fg        = "#${c.text}";
      "fg+"     = "#${c.text}";
      hl        = "#${c.accent}";
      "hl+"     = "#${c.accent}";
      border    = "#${c.subtle}";
      prompt    = "#${c.secondary}";
      pointer   = "#${c.accent}";
      marker    = "#${c.highlight}";
      spinner   = "#${c.secondary}";
      header    = "#${c.subtle}";
    };
    enableZshIntegration = true;
    package = pkgs.fzf;
    fileWidgetOptions = [
      "--preview 'bat -n --color=always --line-range :500 {}'"
    ];
    changeDirWidgetOptions = [
      "--preview 'lsd --tree --depth=2 {} | head -200'"
    ];
  };
}
