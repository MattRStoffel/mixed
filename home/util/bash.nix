{pkgs, ...}: {
  programs.bash = {
    enable = true;
    enableCompletion = true;

    initExtra = ''
      source ${./zship}
    '';
  };
}
