let
  theme = import ../../theme.nix;
  c = theme.colors;
  f = theme.fonts;
in ''
  * {
    font-family: "${f.ui}", "${f.mono}";
    font-size: ${toString f.size}px;
    border: none;
    min-height: 0;
  }

  window#waybar {
    background: transparent;
  }

  #workspaces,
  #window,
  #clock,
  #battery,
  #pulseaudio,
  #network,
  #tray {
    background: ${c.backgroundAlpha};
    color: #${c.text};
    padding: 2px 14px;
    border-radius: 8px;
    border: 1px solid ${c.accentAlpha};
  }

  #workspaces { padding: 0; }

  #workspaces button {
    padding: 0 10px;
    color: #${c.subtle};
    border-radius: 5px;
    transition: all 0.3s ease;
  }

  #workspaces button.focused {
    color: #${c.accent};
    background: #${c.surface};
  }

  #workspaces button.urgent { color: #${c.urgent}; }

  #window {
    background: transparent;
    border: none;
    font-style: italic;
  }

  #clock { color: #${c.secondary}; }

  #battery.charging { color: #${c.highlight}; }

  #battery.critical:not(.charging) {
    background-color: #${c.urgent};
    color: #${c.text};
    animation-name: blink;
    animation-duration: 0.5s;
    animation-timing-function: linear;
    animation-iteration-count: infinite;
    animation-direction: alternate;
  }

  @keyframes blink {
    to { background-color: #${c.background}; color: #${c.urgent}; }
  }
''
