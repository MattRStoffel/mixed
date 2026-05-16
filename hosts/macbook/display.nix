{ pkgs, ... }: {
  programs.sway.enable   = true;

  # greetd — minimal Wayland-native session manager; launches Sway directly
  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "${pkgs.sway}/bin/sway";
      user    = "matt";
    };
  };

  # wl-clipboard lives here because wl-copy/wl-paste are needed at the
  # compositor level (e.g. copy from a root terminal before home-manager loads)
  environment.systemPackages = with pkgs; [
    wl-clipboard
  ];
}
