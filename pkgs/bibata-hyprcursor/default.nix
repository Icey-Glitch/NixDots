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
    url = "https://cdn.discordapp.com/attachments/1216066899729977435/1216076659149504643/HyprBibataModernClassicSVG.tar.gz?ex=667510e5&is=6673bf65&hm=e87636083ccb98d4ac6d6e815a9ea853bb958ccc80a83997a53127645fd9ac1b&";
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
