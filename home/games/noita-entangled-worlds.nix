{pkgs, ...}:
let
  noita-entangled-worlds = pkgs.stdenvNoCC.mkDerivation {
    pname = "noita-entangled-worlds";
    version = "1.6.2";

    src = pkgs.fetchurl {
      url = "https://github.com/IntQuant/noita_entangled_worlds/releases/download/v1.6.2/noita-proxy-linux.zip";
      sha256 = "0kb0q6nyjd5hq59rgbaxjnlkml3yplrqxi40fhkird3awkqrh91f";
    };

    nativeBuildInputs = [ pkgs.unzip ];

    unpackPhase = "unzip $src";

    installPhase = ''
      install -Dm755 noita_proxy.x86_64 $out/bin/noita-proxy
      install -Dm644 libsteam_api.so $out/bin/libsteam_api.so
    '';
  };
in {
  home.packages = [ noita-entangled-worlds ];
}
