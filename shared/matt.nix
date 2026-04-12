{ pkgs, ... }: {
	users.users.matt = {
    name = "matt";
	}// (if pkgs.stdenv.isDarwin then {
    home = "/Users/matt";
	} else {	
		isNormalUser = true;
    extraGroups = ["wheel"];
    initialPassword = "poop";
	});
}
