{config, pkgs, lib, ...}:
let
  cfg = config.programs.nvim-nix.languages;
  file_to_not_import = [
  "default.nix"
  ];

  get-import-dir = dir: ignore: import ../../util/get-import-dir.nix {inherit lib; inherit dir; inherit ignore;};

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
  };


  config.vim = lib.mkIf cfg.enable {
    
  };
}
