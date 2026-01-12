{config, lib, pkgs, ...}:

let
  name = "js-ts";
  lsp-name = "ts";

  cfg = config.programs.nvim-nix.languages;
in
{
  options.programs.nvim-nix.languages.web."${name}" = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "Enable ${name} language module";
      default = true;
    };
  };

  config.vim = lib.mkIf (cfg.enable && cfg.web."${name}".enable) {
    languages."${lsp-name}" = {
      enable = true;
      treesitter.enable = cfg.treesitter;
      lsp.enable = cfg.lsp;
      format.enable = cfg.format;
    };
  };
}
