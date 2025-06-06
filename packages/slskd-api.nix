{
  lib,
  fetchPypi,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
    pname = "slskd-api";
    version = "0.1.5";
    #pyproject = false;

    src = fetchPypi {
        inherit pname version;
        hash = "sha256-LmWP7bnK5IVid255qS2NGOmyKzGpUl3xsO5vi5uJI88=";
    };

    build-system = with python3Packages; [
        setuptools
        setuptools-git-versioning
        pip
    ];

    dependencies = with python3Packages; [
        requests
    ];

    meta = with lib; {
        description = "slskd-api";
        platforms = platforms.unix;
    };
}
