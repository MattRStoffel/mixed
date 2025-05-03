{pkgs, ...}: {
  programs.ripgrep = {
    enable = true;
    arguments = [];
    package = pkgs.ripgrep;
  };
}
