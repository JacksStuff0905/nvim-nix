{config, lib, pkgs, ...}:
let
name = "treesitter";

cfg = config.programs.nvim-nix.plugins.${name};
in
{
  options.programs.nvim-nix.plugins.${name} = {
    enable = lib.mkEnableOption "Enable ${name} plugin module";

    context = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
      max-lines = lib.mkOption {
        type = lib.types.int;
        default = 2;
      };
    };

    textobjects = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };

      lookahead = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };

    };
    keymaps = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };

      select = lib.mkOption {
        type = lib.types.attrsOf lib.types.str;
        default = {
          "af" = "@function.outer";
          "if" = "@function.inner";
          "ac" = "@class.outer";
          "ic" = "@class.inner";
        };
      };
      move = lib.mkOption {
        type = lib.types.attrsOf (lib.types.attrsOf lib.types.str);
          default = {
            goto_next_start = {
              "]m" = "@function.outer";
              "]]" = "@class.outer";
            };
            goto_next_end = {
              "]M" = "@function.outer";
              "][" = "@class.outer";
            };
            goto_previous_start = {
              "[m" = "@function.outer";
              "[[" = "@class.outer";
            };
            goto_previous_end = {
              "[M" = "@function.outer";
              "[]" = "@class.outer";
            };
          };
      };
    };
    };

    config.vim = lib.mkIf cfg.enable {
      treesitter = {
        enable = true;
        indent.enable = true;
        textobjects = {
          setupOpts = {
            enable = true;
            select = {
              keymaps = cfg.keymaps.select;
              lookahead = cfg.textobjects.lookahead;
            };
            move = lib.mkMerge [
            {
              enable = true;
              set_jumps = true;

            }
            cfg.keymaps.move
            ];
          };
        };

        context = {
          enable = cfg.context.enable;
          setupOpts = {
            max_lines = cfg.context.max-lines;
          };
        };
      };
    };
  }
