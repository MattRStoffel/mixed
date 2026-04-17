{pkgs, ...}: {
	users.users.matt = {
    name = "matt";
	} // (if pkgs.stdenv.isDarwin then {
    home = "/Users/matt";
	} else {	
		isNormalUser = true;
    extraGroups = ["wheel"];
    initialPassword = "poop";
	});
  nix.settings.experimental-features = ["nix-command" "flakes"];
  nixpkgs.config.allowUnfree = true;

  time.timeZone = "America/Los_Angeles";
}
