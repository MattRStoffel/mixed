{pkgs, ...}: {
  programs.lsd = {
    enable = true;
    enableAliases = true;
    # package = pkgs.lsd;
  };
}
