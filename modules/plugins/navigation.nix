{
  config,
  lib,
  pkgs,
  ...
}:
let
  name = "navigation";

  cfg = config.programs.nvim-nix.plugins.${name};
in
{
  options.programs.nvim-nix.plugins.${name} = {
    enable = lib.mkEnableOption "Enable ${name} plugin module";

    leap = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
    };
  };

  config.vim = lib.mkIf cfg.enable {
    utility.motion.leap = lib.mkIf cfg.leap.enable {
      enable = true;
    };
  };
}
