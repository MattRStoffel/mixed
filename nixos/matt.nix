{...}: {
  imports = [
    ../home
  ];

  users.users.matt = {
    isNormalUser = true;
    extraGroups = ["wheel"];
    initialPassword = "poop";
  };
}
