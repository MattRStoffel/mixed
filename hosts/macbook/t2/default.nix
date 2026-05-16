{pkgs, ...}: {
  imports = [
  ];

  # hid_appletb_kbd defaults to autodim=Y / idle_timeout=15s, which powers
  # the Touch Bar off after 15 seconds and it doesn't reliably wake — the
  # root cause of intermittent Touch Bar behaviour on T2 Macs.
  boot.extraModprobeConfig = ''
    options hid_appletb_kbd autodim=N
  '';

  hardware.firmware = [
    (pkgs.stdenvNoCC.mkDerivation (final: {
      name = "brcm-firmware";
      src = ./brcm;
      installPhase = ''
        mkdir -p $out/lib/firmware/brcm
        cp ${final.src}/* "$out/lib/firmware/brcm"
      '';
    }))
  ];
}
