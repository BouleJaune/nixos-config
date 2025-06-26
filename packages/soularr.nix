{
  lib,
  fetchFromGitHub,
  pkgs,
  python3Packages,
}:
let
    slskd-api = pkgs.callPackage ./slskd-api.nix {};
in
python3Packages.buildPythonPackage rec {
    pname = "soularr";
    version = "1.0";
    pyproject = false;

    src = fetchFromGitHub {
        owner = "mrusse";
        repo = "soularr";
        rev = "main";
        hash = "sha256-zwYwwGwIgw8LPrk04UxUW2Wl6l42mcFa1QKmYdZL0JM=";
    };
    
    dependencies =  [
        python3Packages.music-tag
        python3Packages.pyarr
        slskd-api
    ];

  installPhase = ''
    mkdir -p $out/bin
    cp soularr.py $out/bin/soularr
    chmod +x $out/bin/soularr
    patchShebangs $out/bin/soularr
  '';


    meta = with lib; {
        description = "soularr";
        platforms = platforms.unix;
        mainProgram = "soularr";
    };
}
