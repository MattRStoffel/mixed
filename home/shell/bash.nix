{pkgs, ...}: {
  programs.bash = {
    enable = true;
    enableCompletion = true;
    initExtra = ''
      flake() {
      	nix flake init --template "https://flakehub.com/f/the-nix-way/dev-templates/*#$1"
      }
    '';
  };
}
