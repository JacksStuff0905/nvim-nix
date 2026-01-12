{config, lib, pkgs, ...}:

let
  name = "python";
  lsp-name = "python";

  cfg = config.programs.nvim-nix.languages;
in
{
  options.programs.nvim-nix.languages."${name}" = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "Enable ${name} language module";
      default = true;
    };
  };

  config.vim = lib.mkIf (cfg.enable && cfg."${name}".enable) {
    languages."${lsp-name}" = {
      enable = true;
      treesitter.enable = cfg.treesitter;
      lsp.enable = cfg.lsp;
      format.enable = cfg.format;
    };
  };
}
