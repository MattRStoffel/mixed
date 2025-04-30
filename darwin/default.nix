{...}: {
  imports = [
    ./system.nix
    ./homebrew.nix
  ];
   users.users.matt = {
     name = "matt";
     home = "/Users/matt";
   };
}
