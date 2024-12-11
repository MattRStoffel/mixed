{
  pkgs,
  ...
}: {
  imports = [
    ./fonts.nix
    ./nextcloud.nix
    ./nvim
  ];
  
  programs.steam.enable = true;

  home-manager.users.matt = {
    home = {
      shellAliases = {
        ":q" = "exit";
	"ls" = "lsd";
	"la" = "lsd -a";
	"ll" = "lsd -l";
	"lt" = "lsd --tree";
	"lla" ="lsd -la";
	"llt" ="lsd -l --tree";
      };
      stateVersion = "24.11";
      packages = with pkgs; [
        legcord
        nextcloud-client
        unzip
      ];
    };
    programs = {
      kitty.enable = true;
      firefox.enable = true;
      lsd.enable = true;
      fzf.enable = true;
      fd.enable = true;
      ripgrep.enable = true;
      starship.enable = true;
      git = {
        enable = true;
      };
      zoxide = {
        enable = true;
        enableBashIntegration = true;
      };
    };
  };
}
