{ lib, ... }:

{

  options.dashy.services.entry = lib.mkOption {
    type = lib.types.listOf lib.types.attrs;
    default = [];
    description = "Extra values to be added to items in dashy services section";
  };

  options.dashy.xeniarr.entry = lib.mkOption {
    type = lib.types.listOf lib.types.attrs;
    default = [];
    description = "Extra values to be added to items in dashy xeniarr section";
  };

  options.dashy.monitoring.entry = lib.mkOption {
    type = lib.types.listOf lib.types.attrs;
    default = [];
    description = "Extra values to be added to items in dashy monitoring section";
  };

}
