{pkgs, ...}: {
  programs.btop = {
    enable = true;
    settings = {
      theme_background = false;
    };
    package = pkgs.btop;
  };
}
