{
  lib,
  fetchPypi,
  zeroconf, 
  aiohttp,
  aiofiles,
  pyyaml,
  setuptools,
  setuptools-git-versioning,
  buildPythonPackage,
  pip
}:

buildPythonPackage rec {
  pname = "aioWiserHeatAPI";
  version = "1.7.0";

  src = fetchPypi {
    pname = "aiowiserheatapi"; 
    inherit version;
    hash = "sha256-QJPeUAuNqX4hrMTvOwhIR809jPUIAGgSXZaHfn6OuUc=";
  };

  build-system =  [
      setuptools
      setuptools-git-versioning
      pip
  ];

  dependencies =  [ zeroconf aiohttp aiofiles pyyaml ]; 


  pythonImportsCheck = [ "aioWiserHeatAPI" ];

  meta = with lib; {
    description = "Drayton Wiser Hub API Async v1.7.0";
    homepage = "https://github.com/msp1974/aioWiserHeatAPI";
    license = licenses.mit;
  };
}
