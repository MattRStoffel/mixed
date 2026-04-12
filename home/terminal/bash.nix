{pkgs, ...}: {
  programs.bash = {
    enable = true;
    # initExtra = ''
    #   flake() {
    #   	nix flake init --template "https://flakehub.com/f/the-nix-way/dev-templates/*#$1"
    #   }
    # '';
  };
}
