{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "enhanced-shutter-card";
  version = "1.3.1";

  src = fetchFromGitHub {
      owner = "marcelhoogantink";
      repo  = "enhanced-shutter-card";
      rev   = "v${version}";
      hash  = "sha256-u9u3CtpNlZ/wWIoGND3HUjNk6UQbJb3RAezjEmCj5xQ=";
    };

  installPhase = ''
    mkdir -p $out/
    #cp dist/enhanced-shutter-card.js $out/
    cp -r dist/* $out/
  '';

  meta = with lib; {
    description = "Enhanced Shutter Card";
    homepage = "https://github.com/marcelhoogantink/enhanced-shutter-card";
    license = licenses.gpl3Only;
    platforms = platforms.all;
  };
}
