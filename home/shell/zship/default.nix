{pkgs, ...}: {
  programs.bash.initExtra = ''
    source ${./zship.sh}
  '';
}
