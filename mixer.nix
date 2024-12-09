{
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    (writeShellScriptBin "mixed" ''
      # A rebuild script that commits on a successful build
      set -e

      # cd to your config dir
      pushd ~/.mixed

      $EDITOR .

      # Early return if no changes were detected (thanks @singiamtel!)
      if git diff --quiet '*.nix' '*.lua'; then
          echo "No changes, exiting."
          popd
          exit 0
      fi

      git add .

      # Shows your changes
      git diff -U0 '*.nix'

      # Rebuild, output simplified errors, log trackebacks
      sudo nixos-rebuild switch --flake . &>nixos-switch.log || (cat nixos-switch.log | grep --color error && exit 1)

      # Get current generation metadatA
      current=$(nixos-rebuild list-generations | grep current)

      # Commit all changes witih the generation metadata
      git commit -am "$current"

      popd
    '')
  ];
}
