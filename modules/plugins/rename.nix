{config, lib, pkgs, ...}:
let
        name = "rename";

        cfg = config.nvim-nix.plugins.${name};
in
{
        options.nvim-nix.plugins.${name} = {
                enable = lib.mkEnableOption "Enable ${name} plugin module";
                title = lib.mkOption {
                        type = lib.types.str;
                        description = "The popup title, shown if `border` is true";
                        default = "Rename";
                };

                # The padding around the popup content
                padding = {
                        top = lib.mkOption {
                                type = lib.types.int;
                                default = 0;
                        };
                        left = lib.mkOption {
                                type = lib.types.int;
                                default = 0;
                        };
                        bottom = lib.mkOption {
                                type = lib.types.int;
                                default = 0;
                        };
                        right = lib.mkOption {
                                type = lib.types.int;
                                default = 0;
                        };
                };

                width = {
                        min = lib.mkOption {
                                type = lib.types.int;
                                description = "The minimum width of the popup";
                                default = 15;
                        };

                        max = lib.mkOption {
                                type = lib.types.int;
                                description = "The maximum width of the popup";
                                default = 45;
                        };
                };

                border = {
                        enable = lib.mkOption {
                                type = lib.types.bool;
                                description = "Whether or not to shown a border around the popup";
                                default = true;
                        };

                        chars = lib.mkOption {
                                type = lib.types.listOf lib.types.str;
                                description = "The characters which make up the border";
                                default = [ "─" "│" "─" "│" "╭" "╮" "╯" "╰" ];
                        };
                };

                show_refs = lib.mkOption {
                        type = lib.types.bool;
                        default = true;
                        description = "Whether or not to highlight the current word references through LSP";
                };
                
                with_qf_list = lib.mkOption {
                        type = lib.types.bool;
                        default = true;
                        description = "Whether or not to add resulting changes to the quickfix list";
                };

                with_popup = lib.mkOption {
                        type = lib.types.bool;
                        default = true;
                        description = "Whether or not to enter the new name through the UI or Neovim's `input` prompt";
                };

                # Custom handler to be run after successfully renaming the word. Receives
                # the LSP 'textDocument/rename' raw response as its parameter.
                handler = lib.mkOption {
                        type = lib.types.str;
                        default = "nil";
                };

                keymaps = {
                        enable = lib.mkOption { type = lib.types.bool; default = true; };
                        in-buffer = {
                                cursor_start = lib.mkOption {
                                        type = lib.types.str;
                                        default = "<leader>st";
                                };
                                cursor_end = lib.mkOption {
                                        type = lib.types.str;
                                        default = "<leader>en";
                                };
                                cursor_w_start = lib.mkOption {
                                        type = lib.types.str;
                                        default = "<leader>ws";
                                };
                                cursor_w_end = lib.mkOption {
                                        type = lib.types.str;
                                        default = "<leader>we";
                                };
                                clear_line = lib.mkOption {
                                        type = lib.types.str;
                                        default = "<leader>cl";
                                };
                                undo = lib.mkOption {
                                        type = lib.types.str;
                                        default = "<leader>un";
                                };
                                redo = lib.mkOption {
                                        type = lib.types.str;
                                        default = "<leader>re";
                                };
                        };

                        rename = {
                                enable = lib.mkOption { type = lib.types.bool; default = true; };

                                key = lib.mkOption {
                                        type = lib.types.str;
                                        default = "<leader>rn";
                                };
                        };
                };
        };

	config.vim = lib.mkIf cfg.enable {
                extraPlugins.renamer = {
                
                        package = pkgs.vimPlugins.renamer-nvim;

                        setup = ''
                        require("renamer").setup({
                                title = ${cfg.title},
                                padding = {
                                  top = ${toString cfg.padding.top},
                                  left = ${toString cfg.padding.left},
                                  bottom = ${toString cfg.padding.bottom},
                                  right = ${toString cfg.padding.right},
                                },
                                min_width = ${toString cfg.width.min},
                                max_width = ${toString cfg.width.max},
                                border = ${if cfg.border.enable then "true" else "false"},
                                border_chars = {"${builtins.concatStringsSep "\", \"" cfg.border.chars}"},
                                show_refs = ${if cfg.show_refs then "true" else "false"},
                                with_qf_list = ${if cfg.with_qf_list then "true" else "false"},
                                with_popup = ${if cfg.with_popup then "true" else "false"},
                                mappings = {
                                        ["${cfg.keymaps.in-buffer.cursor_start}"] = require("renamer.mappings.utils").set_cursor_to_start,
                                        ["${cfg.keymaps.in-buffer.cursor_end}"] = require("renamer.mappings.utils").set_cursor_to_end,
                                        ["${cfg.keymaps.in-buffer.cursor_w_end}"] = require("renamer.mappings.utils").set_cursor_to_word_end,
                                        ["${cfg.keymaps.in-buffer.cursor_w_start}"] = require("renamer.mappings.utils").set_cursor_to_word_start,
                                        ["${cfg.keymaps.in-buffer.clear_line}"] = require("renamer.mappings.utils").clear_line,
                                        ["${cfg.keymaps.in-buffer.undo}"] = require("renamer.mappings.utils").undo,
                                        ["${cfg.keymaps.in-buffer.redo}"] = require("renamer.mappings.utils").redo,
                                },
                                handler = ${cfg.handler},
                        })
                        '';
                };

                # Keybinds
                keymaps = lib.mkIf cfg.keymaps.enable [
                        (lib.mkIf cfg.keymaps.rename.enable {
                                 key = cfg.keymaps.rename.key;
                                 mode = "n";
                                 silent = true;
                                 lua = true;
                                 action = "require('renamer').rename";
                        })
                ];
        };
}
