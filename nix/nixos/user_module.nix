{ lib, ... }:
{
  lib.options.services.userdata = {
    username = lib.mkOption {
      type = lib.types.str;
      default = "Liqyid";
    };

  };
}
