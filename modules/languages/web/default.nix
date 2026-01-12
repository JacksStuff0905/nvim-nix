{config, pkgs, lib, ...}:
let
  cfg = config.programs.nvim-nix.languages;
in
{
  imports = [
    ./html.nix
    ./css.nix
    ./js-ts.nix
  ];

  options.programs.nvim-nix.languages.web = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };
  };
}
