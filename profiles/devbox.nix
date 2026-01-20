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
  config.programs.nvim-nix = lib.mkIf (cfg.profile == "devbox") {
    # Disable spellcheck
    opts.spelling.enable = lib.mkDefault false;

    plugins = {
      colorizer.enable = lib.mkDefault true;
      git.enable = lib.mkDefault true;
      rename.enable = lib.mkDefault true;

      # Disable SudaWrite, since there's no use for it
      sudo.enable = lib.mkDefault false;
    };

    languages = {
      enable = lib.mkDefault true;
    };
  };
}
