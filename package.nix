{
  stdenv,
  lib,
  codespell,
  dpkg,
  fetchFromGitLab,
  gnumake,
  help2man,
  makeWrapper,
  shellcheck,
}:
let
  runtime-deps = [
    codespell
    dpkg
    gnumake
    help2man
    shellcheck
  ];
  runtime-path = lib.makeBinPath runtime-deps;
in
stdenv.mkDerivation {
  pname = "debcraft";
  version = "0.6.0";
  src = fetchFromGitLab {
    domain = "salsa.debian.org";
    owner = "debian";
    repo = "debcraft";
    tag = "debian/0.6.0";
    hash = "sha256-Al2sFFPj22gxWaBiLnDC4Yj8JCROC28r/G9HfG+im8c=";
  };
  nativeBuildInputs = [ makeWrapper ];
  buildInputs = runtime-deps;
  # it'd patch the shebangs of the scripts which end up being executed in the docker container too,
  # messing things up
  dontPatchShebangs = true;
  dontBuild = true;
  installPhase = ''
    mkdir -p $out/bin $out/share
    cp -r src $out/share/debcraft
    mv debcraft.sh $out/bin/debcraft

    substituteInPlace $out/bin/debcraft \
      --replace-fail \
          'DEBCRAFT_LIB_DIR="/usr/share/debcraft"'\
          "DEBCRAFT_LIB_DIR=$out/share/debcraft"
    wrapProgram $out/bin/debcraft \
      --prefix PATH : ${runtime-path}

    patchShebangs $out/bin
  '';
  meta = {
    description = "Easy, fast and secure way to build Debian packages";
    homepage = "https://salsa.debian.org/debian/debcraft";
    license = lib.licenses.gpl3Plus;
  };
}
