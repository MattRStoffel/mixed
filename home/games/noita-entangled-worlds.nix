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
      install -Dm755 noita_proxy.x86_64 $out/libexec/noita_proxy
      install -Dm644 libsteam_api.so $out/libexec/libsteam_api.so

      mkdir -p $out/bin
      cat > $out/bin/noita-proxy << 'EOF'
#!/bin/sh
dir="$HOME/.local/share/noita-entangled-worlds"
mkdir -p "$dir"
cp -u @out@/libexec/noita_proxy "$dir/noita_proxy"
cp -u @out@/libexec/libsteam_api.so "$dir/libsteam_api.so"
chmod +x "$dir/noita_proxy"
exec "$dir/noita_proxy" "$@"
EOF
      chmod +x $out/bin/noita-proxy
      substituteInPlace $out/bin/noita-proxy --replace @out@ $out
    '';
  };
in {
  home.packages = [ noita-entangled-worlds ];
}
