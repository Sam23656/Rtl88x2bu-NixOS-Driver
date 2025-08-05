{ lib, stdenv, fetchFromGitHub, kernel, bc, nukeReferences }:

stdenv.mkDerivation {
  pname = "rtl88x2bu-rincat";
  version = "${kernel.version}-unstable-2025-06-11";

  src = fetchFromGitHub {
    owner = "RinCat";
    repo = "RTL88x2BU-Linux-Driver";
    rev = "77a82dbac7192bb49fa87458561b0f2455cdc88f";
    sha256 = "sha256-kBBm7LYox3V3uyChbY9USPqhQUA40mpqVwgglAxpMOM=";
  };

  nativeBuildInputs = [ bc nukeReferences ];
  buildInputs = kernel.moduleBuildDependencies;

  makeFlags = [
    "KSRC=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "KVER=${kernel.modDirVersion}"
  ];

  enableParallelBuilding = true;

  buildPhase = ''
    runHook preBuild
    make $makeFlags
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/lib/modules/${kernel.modDirVersion}/kernel/drivers/net/wireless/
    cp 88x2bu.ko $out/lib/modules/${kernel.modDirVersion}/kernel/drivers/net/wireless/
    runHook postInstall
  '';

  postInstall = ''
    nuke-refs $out/lib/modules/*/kernel/drivers/net/wireless/88x2bu.ko
  '';

  meta = with lib; {
    description = "Realtek RTL88x2BU WiFi driver (RinCat fork)";
    homepage = "https://github.com/RinCat/RTL88x2BU-Linux-Driver";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
  };
}