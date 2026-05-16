let
  hexDigits = [ "0" "1" "2" "3" "4" "5" "6" "7" "8" "9" "a" "b" "c" "d" "e" "f" ];

  hexVal = c: {
    "0"=0; "1"=1; "2"=2; "3"=3; "4"=4; "5"=5; "6"=6; "7"=7;
    "8"=8; "9"=9; "a"=10; "b"=11; "c"=12; "d"=13; "e"=14; "f"=15;
    "A"=10; "B"=11; "C"=12; "D"=13; "E"=14; "F"=15;
  }.${c};

  parseByte = s:
    hexVal (builtins.substring 0 1 s) * 16 +
    hexVal (builtins.substring 1 1 s);

  toByte = n:
    let v = if n > 255 then 255 else if n < 0 then 0 else n;
    in builtins.elemAt hexDigits (v / 16)
     + builtins.elemAt hexDigits (v - (v / 16) * 16);

  # Blend a hex color toward white. pct=25 → 25% brighter.
  brighten = hex: pct:
    let
      r = parseByte (builtins.substring 0 2 hex);
      g = parseByte (builtins.substring 2 2 hex);
      b = parseByte (builtins.substring 4 2 hex);
    in
    toByte (r + (255 - r) * pct / 100) +
    toByte (g + (255 - g) * pct / 100) +
    toByte (b + (255 - b) * pct / 100);

in {
  colors = rec {
    # --- UI semantic colors ---
    background = "1e1b2e"; # #1e1b2e
    surface    = "2e2a46"; # #2e2a46
    text       = "f0ebff"; # #f0ebff
    subtle     = "8887a8"; # #8887a8
    accent     = "ff79c6"; # #ff79c6
    secondary  = "bd93f9"; # #bd93f9
    highlight  = "f1fa8c"; # #f1fa8c
    urgent     = "ff5555"; # #ff5555

    # --- Terminal base (0-7) ---
    black   = "000000"; # #000000
    red     = "ff5555"; # #ff5555
    green   = "50fa7b"; # #50fa7b
    yellow  = "f1fa8c"; # #f1fa8c
    blue    = "6cb6ff"; # #6cb6ff
    magenta = "bd93f9"; # #bd93f9
    cyan    = "8be9fd"; # #8be9fd
    white   = "f0ebff"; # #f0ebff

    # --- Terminal bright (8-15) — derived via brighten ---
    brightBlack   = brighten black   40; # #666666
    brightRed     = brighten red     25; # #ff7f7f
    brightGreen   = brighten green   25; # #7bfb9c
    brightYellow  = brighten yellow  25; # #f4fba8
    brightBlue    = brighten blue    25; # #90c8ff
    brightMagenta = brighten magenta 25; # #cdaefa
    brightCyan    = brighten cyan    25; # #a8eefd
    brightWhite   = brighten white   10; # #f1edff

    # --- Alpha variants ---
    backgroundAlpha = "rgba(30, 27, 46, 0.8)";
    accentAlpha     = "rgba(151, 115, 200, 0.2)";
  };

  fonts = {
    ui       = "Hack Nerd Font";
    mono     = "Hack Nerd Font";
    size     = 13;
    termSize = 10;
  };
}
