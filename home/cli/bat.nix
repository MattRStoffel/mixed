{ pkgs, ... }: {
  programs.bat = {
    enable  = true;
    config.theme = "ansi";
    package = pkgs.bat;
  };
}
