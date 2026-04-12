{pkgs, ...}: {
  programs.direnv = {
    enable = true;
    silent = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
    config.hide_env_diff = true;
    package = pkgs.direnv;
  };
}
