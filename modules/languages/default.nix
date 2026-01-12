{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.programs.nvim-nix.languages;
  file_to_not_import = [
    "default.nix"
  ];

  get-import-dir =
    dir: ignore:
    import ../../util/get-import-dir.nix {
      inherit lib;
      inherit dir;
      inherit ignore;
    };

in
{
  imports = get-import-dir ./. file_to_not_import;

  options.programs.nvim-nix.languages = {
    enable = lib.mkEnableOption "Enable the language / LSP module";
    treesitter = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };
    lsp = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };
    format = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };
    null-ls = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
    };
    completions = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    vim = {
      lsp.enable = cfg.lsp;
      lsp.null-ls.enable = cfg.null-ls.enable;
    };
    programs.nvim-nix.plugins.completions.enable = cfg.completions;
  };
}
