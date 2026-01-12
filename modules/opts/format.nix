{config, lib, ...}:

let
  cfg = config.programs.nvim-nix.opts.format;
in
  {
  options.programs.nvim-nix.opts.format = {
    tab = {
      expand = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
      width = lib.mkOption {
        type = lib.types.int;
        default = 2;
      };
      soft-width = lib.mkOption {
        type = lib.types.int;
        default = cfg.tab.width;
      };
      shift-width = lib.mkOption {
        type = lib.types.int;
        default = cfg.tab.width;
      };
    };

    numbers = lib.mkOption {
      type = lib.types.enum ["none" "relative" "absolute"];
      default = "relative";
    };

    scroll-margin = lib.mkOption {
      type = lib.types.int;
      default = 5;
    };

    redraw = {
      lazy = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
      fast = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
    };

    window-borders = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };

      style = lib.mkOption {
        type = lib.types.either (lib.types.enum
          [ "bold" "double" "none"
            "rounded" "shadow" "single"
            "solid" ]) (lib.types.listOf lib.types.str);
        default = "rounded";
      };
    };
  };


  config.vim = lib.mkIf config.programs.nvim-nix.opts.enable {
    options.expandtab = cfg.tab.expand;
    options.tabstop = cfg.tab.width;
    options.softtabstop = cfg.tab.soft-width;
    options.shiftwidth = cfg.tab.shift-width;
    options.number = cfg.numbers != "none";
    options.relativenumber = cfg.numbers == "relative";
    options.scrolloff = cfg.scroll-margin;

    options.lazyredraw = cfg.redraw.lazy;

    ui.borders.enable = cfg.window-borders.enable;
    ui.borders.globalStyle = cfg.window-borders.style;
  };
}
