{config, lib, pkgs, ...}:
let
name = "scrollbar";

cfg = config.programs.nvim-nix.plugins.${name};
in
{
  options.programs.nvim-nix.plugins.${name} = {
    enable = lib.mkEnableOption "Enable ${name} plugin module";

    excluded = {
      buftypes = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = ["terminal"];
      };

      filetypes = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [
          "blink-cmp-menu"
          "dropbar_menu"
          "dropbar_menu_fzf"
          "DressingInput"
          "cmp_docs"
          "cmp_menu"
          "noice"
          "prompt"
          "TelescopePrompt"
        ];
      };
    };

    autocmd = {
      render = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [
          "BufWinEnter"
          "TabEnter"
          "TermEnter"
          "WinEnter"
          "CmdwinLeave"
          "TextChanged"
          "VimResized"
          "WinScrolled"
        ];
      };
      clear = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [
          "BufWinLeave"
          "TabLeave"
          "TermLeave"
          "WinLeave"
        ];
      };
    };

    handle = {
        text = lib.mkOption {
                type = lib.types.str;
                default = " ";
        };
        
    };

    handlers = {
        git = lib.mkOption {
                type = lib.types.bool;
                default = true;
        };
    };

        marks = {
                cursor = lib.mkOption {
                        type = lib.types.either lib.types.str (lib.types.listOf lib.types.str);
                        default = "I"; # •
                };
                
                info = lib.mkOption {
                        type = lib.types.either lib.types.str (lib.types.listOf lib.types.str);
                        default = [ "-" "=" ];
                };
                search = lib.mkOption {
                        type = lib.types.either lib.types.str (lib.types.listOf lib.types.str);
                        default = cfg.marks.info;
                };
                error = lib.mkOption {
                        type = lib.types.either lib.types.str (lib.types.listOf lib.types.str);
                        default = cfg.marks.info;
                };
                warn = lib.mkOption {
                        type = lib.types.either lib.types.str (lib.types.listOf lib.types.str);
                        default = cfg.marks.info;
                };
                hint = lib.mkOption {
                        type = lib.types.either lib.types.str (lib.types.listOf lib.types.str);
                        default = cfg.marks.info;
                };
                misc = lib.mkOption {
                        type = lib.types.either lib.types.str (lib.types.listOf lib.types.str);
                        default = cfg.marks.info;
                };

                git = {
                        add = lib.mkOption {
                                type = lib.types.either lib.types.str (lib.types.listOf lib.types.str);
                                default = "+";
                        };
                        change = lib.mkOption {
                                type = lib.types.either lib.types.str (lib.types.listOf lib.types.str);
                                default = "~";
                        };
                        delete = lib.mkOption {
                                type = lib.types.either lib.types.str (lib.types.listOf lib.types.str);
                                default = "x";
                        };
                };
        };
  };

  config.vim = lib.mkIf cfg.enable {
    visuals.nvim-scrollbar = {
      enable = true;
      setupOpts = {
        handle = {
          text = cfg.handle.text;
        };

        excluded_buftypes = cfg.excluded.buftypes;
        excluded_filetypes = cfg.excluded.filetypes;

        autocmd = {
          render = cfg.autocmd.render;
          clear = cfg.autocmd.clear;
        };
marks = {
        Cursor = {
            text = cfg.marks.cursor;
            priority = 0;
            highlight = "Normal";
        };
        Search = {
            text = cfg.marks.search;
            priority = 1;
            highlight = "Search";
        };
        Error = {
            text = cfg.marks.error;
            priority = 2;
            highlight = "DiagnosticVirtualTextError";
        };
        Warn = {
            text = cfg.marks.warn;
            priority = 3;
            highlight = "DiagnosticVirtualTextWarn";
        };
        Info = {
            text = cfg.marks.info;
            priority = 4;
            highlight = "DiagnosticVirtualTextInfo";
        };
        Hint = {
            text = cfg.marks.hint;
            priority = 5;
            highlight = "DiagnosticVirtualTextHint";
        };
        Misc = {
            text = cfg.marks.misc;
            priority = 6;
            highlight = "Normal";
        };
        GitAdd = {
            text = cfg.marks.git.add;
            priority = 7;
            highlight = "GitSignsAdd";
        };
        GitChange = {
            text = cfg.marks.git.change;
            priority = 6;
            highlight = "GitSignsChange";
        };
        GitDelete = {
            text = cfg.marks.git.delete;
            priority = 7;
            highlight = "GitSignsDelete";
        };
    };

        handlers = {
                cursor = true;
                diagnostic = true;
                gitsigns = cfg.handlers.git; # Requires gitsigns
                handle = true;
        };
      };
    };
  };
}
