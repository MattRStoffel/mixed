{pkgs, ...}: {
  programs.git = {
    enable = true;
    ignores = [
      ".DS_Store"
      ".direnv/"
      "node_modules/"
    ];
    settings = {
      user = {
        name = "MattRStoffel";
        email = "Matt@MrStoffel.com";
      };
      aliases = {};
    };
    package = pkgs.git;
  };
}
