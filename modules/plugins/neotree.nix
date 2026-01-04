{config, pkgs, lib, ...}:
let
        cfg = config.programs.nvim-nix.plugins.neo-tree;
in
{
        options.programs.nvim-nix.plugins.neo-tree = {
                enable = lib.mkEnableOption "Enable neo-tree plugin module";
                keymaps = {
                        enable = lib.mkOption {
                                type = lib.types.bool;
                                default = true;
                        };

                        toggle = {
                                enable = lib.mkOption {
                                        type = lib.types.bool;
                                        default = true;
                                };

                                key = lib.mkOption {
                                        type = lib.types.str;
                                        default = "<leader>fs";
                                };
                        };
                };
        };

	config.vim = lib.mkIf cfg.enable {
                filetree.neo-tree = {
                        enable = true;
                        setupOpts = {
                                filesystem = {
                                        filtered_items = {
                                                visible = true; # This is what you want: If you set this to `true`, all "hide" just mean "dimmed out"
                                                hide_dotfiles = false;
                                                hide_gitignored = true;
                                        };
                                };
                                
                                enable_cursor_hijack = true;
                        };
                };

                # Keybinds
                keymaps = lib.mkIf cfg.keymaps.enable [
                        (lib.mkIf cfg.keymaps.toggle.enable {
                                 key = cfg.keymaps.toggle.key;
                                 mode = "n";
                                 silent = true;
                                 action = ":Neotree filesystem toggle left<CR>";
                        })
                ];
	};
}
