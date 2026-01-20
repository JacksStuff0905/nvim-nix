{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.programs.nvim-nix;
in
{
  config.programs.nvim-nix = lib.mkIf (cfg.profile == "basic") {
    plugins = {
      colorizer.enable = lib.mkDefault false;
      git.enable = lib.mkDefault false;
      rename.enable = lib.mkDefault false;
    };

    languages = {
      enable = lib.mkDefault false;
    };
  };
}
