{
  lib,
  stdenvNoCC,
  fetchurl,
  bibata-cursors,
}:
stdenvNoCC.mkDerivation (_finalAttrs: {
  pname = "bibata-hyprcursor";

  inherit (bibata-cursors) version;

  src = fetchurl {
    url = "https://cdn.discordapp.com/attachments/1216066899729977435/1216076659149504643/HyprBibataModernClassicSVG.tar.gz?ex=666fcae5&is=666e7965&hm=1c33b73c3d19cf316a4216d88279be3081715676c31aed7db02fa7a8aa3f90ce&";
    name = "HyprBibataModernClassic.tar.gz";
    hash = "sha256-KDYoULjJC0Nhdx9Pz5Ezq+1F0tWwkVQIc5buy07hO98=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/icons
    cp -r $PWD $out/share/icons

    runHook postInstall
  '';

  meta = {
    description = "Open source, compact, and material designed cursor set";
    homepage = "https://github.com/LOSEARDES77/Bibata-Cursor-hyprcursor";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [fufexan];
  };
})
