{ lib, ... }:

{
  options.dashy.xeniarr.entry = lib.mkOption {
    type = lib.types.listOf lib.types.attrs;
    default = [];
    description = "Extra values to be added to items in dashy sections";
  };
}
