{pkgs, ...}: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    plugins = [
      {
        name = "zsh-nix-shell";
        inherit (pkgs) zsh-nix-shell;
      }
    ];
  };
}
