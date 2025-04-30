{...}: {
  imports = [
    ./direnv.nix
    ./git.nix
    ./nvim
    ./starship.nix
    ./steam.nix
    ./zoxide.nix
    ./zsh.nix
  ];

  programs = {
    bat.enable = true;
    lsd.enable = true;
    fzf.enable = true;
    fd.enable = true;
    ripgrep.enable = true;
    fastlane.enable = true;
    btop.enable = true;
  };
}
