{ config, lib, pkgs, ... }:

let
  cfg = config.programs.nvim-nix.opts.clipboard;
in
{

  options.programs.nvim-nix.opts.clipboard = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };

    registers = lib.mkOption {
      type = lib.types.str;
      default = "unnamedplus";
    };

    providers = {
      wl-copy.enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };

      xclip.enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
    };
  };

  config.vim = lib.mkIf (config.programs.nvim-nix.opts.enable && cfg.enable) {

    # Extra dependencies
    extraPackages = with pkgs; lib.mkMerge [
      [(lib.mkIf cfg.providers.wl-copy.enable wl-clipboard)]
      [(lib.mkIf cfg.providers.xclip.enable xclip)]
    ];

    clipboard = cfg;
  };
}
