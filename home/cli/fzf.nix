{pkgs, ...}: {
  programs.fzf = {
    enable = true;
    colors = {
      bg = "#1e1e1e";
      "bg+" = "#1e1e1e";
      fg = "#d4d4d4";
      "fg+" = "#d4d4d4";
    };
    enableZshIntegration = true;
    package = pkgs.fzf;
    fileWidgetOptions = [
      "--preview 'bat -n --color=always --line-range :500 {}'"
    ];
    changeDirWidgetOptions = [
      "--preview 'lsd --tree --depth=2 {} | head -200'"
    ];
  };
}
