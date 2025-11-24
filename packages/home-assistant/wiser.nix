{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  aiowiserheatapi,
}:

buildHomeAssistantComponent rec {
  owner = "asantaga";
  domain = "wiser";
  version = "3.4.18";

  src = fetchFromGitHub {
    inherit owner;
    repo = "wiserHomeAssistantPlatform";
    tag = "v${version}";
    hash = "sha256-NLytdR0VuskRwmAeYaO7/hfmwBL6Yyk5AbXiZUcLW8o=";
  };
  
  propagatedBuildInputs = [ aiowiserheatapi ];
  dependencies = [ aiowiserheatapi ];

  meta = rec {
    description = "Wiser Home Assistant Integration";
    homepage = "https://github.com/asantaga/wiserHomeAssistantPlatform";
    changelog = "${homepage}/releases/tag/R${version}";
    license = lib.licenses.mit;
  };
}
