{pkgs, ...}: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    initContent = ''
      nix_init_env() {
        nix flake init --template "https://flakehub.com/f/the-nix-way/dev-templates/*#$1"
      }
    '';
    # plugins = [
    #   {
    #     name = "zsh-nix-shell";
    #     inherit (pkgs) zsh-nix-shell;
    #   }
    # ];
  };
}
