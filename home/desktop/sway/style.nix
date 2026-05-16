let
  c = (import ../../theme.nix).colors;
in ''
  gaps inner 6
  gaps outer 3

  default_border pixel 2
  client.focused #${c.accent} #${c.background} #${c.accent} #${c.accent}
''
