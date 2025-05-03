{pkgs, ...}: {
  programs.starship = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    package = pkgs.starship;
  };
}
