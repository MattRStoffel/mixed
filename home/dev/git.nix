{pkgs, ...}: {
  programs.git = {
    enable = true;
    userName = "MattRStoffel";
    userEmail = "Matt@MrStoffel.com";
    ignores = [
      ".DS_Store"
      ".direnv/"
      "node_modules/"
    ];
    aliases = {};
    package = pkgs.git;
  };
}
