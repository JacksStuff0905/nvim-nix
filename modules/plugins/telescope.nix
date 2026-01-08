{config, lib, pkgs, ...}:
let
        name = "telescope";

        cfg = config.nvim-nix.plugins.${name};
in
{
        options.nvim-nix.plugins.${name} = {
                enable = lib.mkEnableOption "Enable ${name} plugin module";

                keymaps = {
                        enable = lib.mkOption { type = lib.types.bool; default = true; };

                        find-files = {
                                enable = lib.mkOption { type = lib.types.bool; default = true; };

                                key = lib.mkOption {
                                        type = lib.types.str;
                                        default = "<leader>fd";
                                };
                        };

                        live-grep = {
                                enable = lib.mkOption { type = lib.types.bool; default = true; };

                                key = lib.mkOption {
                                        type = lib.types.str;
                                        default = "<leader>gr";
                                };
                        };

                        telescope = {
                                enable = lib.mkOption { type = lib.types.bool; default = true; };

                                key = lib.mkOption {
                                        type = lib.types.str;
                                        default = "<leader>tl";
                                };
                        };
                };
        };

	config.vim = lib.mkIf cfg.enable {
                telescope = {
                        enable = true;
                        
                        setupOpts = {
                                pickers = {
                                        find_files = {
                                                hidden = true;
                                        };
                                };
                        };
                };

                extraPlugins = with pkgs.vimPlugins; {
                        telescope-ui-select = {
                                package = pkgs.vimPlugins.telescope-ui-select-nvim ;
                        };
                };

                
                luaConfigRC.telescope-ui-select = ''
                        require("telescope").setup({
                                extensions = {
                                        ["ui-select"] = {
                                                require("telescope.themes").get_dropdown({}),
                                        },
                                },
                        })
                        require("telescope").load_extension("ui-select")
                '';

                # Keybinds
                keymaps = lib.mkIf cfg.keymaps.enable [
                        (lib.mkIf cfg.keymaps.find-files.enable {
                                 key = cfg.keymaps.find-files.key;
                                 mode = "n";
                                 silent = true;
                                 action = ":Telescope find_files<CR>";
                        })
                        (lib.mkIf cfg.keymaps.live-grep.enable {
                                 key = cfg.keymaps.live-grep.key;
                                 mode = "n";
                                 silent = true;
                                 action = ":Telescope live_grep<CR>";
                        })
                        (lib.mkIf cfg.keymaps.telescope.enable {
                                 key = cfg.keymaps.telescope.key;
                                 mode = "n";
                                 silent = true;
                                 action = ":Telescope<CR>";
                        })
                ];
	};
}
