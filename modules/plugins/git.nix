{config, lib, ...}:
let
        name = "git";

        cfg = config.nvim-nix.plugins.${name};
in
{
        options.nvim-nix.plugins.${name} = {
                enable = lib.mkEnableOption "Enable ${name} plugin module";

                gitsigns = {
                        enable = lib.mkOption { type = lib.types.bool; default = true; };
                };

                vim-fugitive = {
                        enable = lib.mkOption { type = lib.types.bool; default = true; };
                };

                keymaps = {
                        enable = lib.mkOption { type = lib.types.bool; default = true; };

                        toggle = {
                                enable = lib.mkOption { type = lib.types.bool; default = true; };

                                key = lib.mkOption {
                                        type = lib.types.str;
                                        default = "<leader>gi";
                                };
                        };
                };
        };

	config.vim = lib.mkIf cfg.enable {
                git = {
                        gitsigns = {
                                enable = cfg.gitsigns.enable;
                        };

                        vim-fugitive = {
                                enable = cfg.vim-fugitive.enable;
                        };
                };

                # Keybinds
                keymaps = lib.mkIf cfg.keymaps.enable [
                        (lib.mkIf cfg.keymaps.toggle.enable {
                                 key = cfg.keymaps.toggle.key;
                                 mode = "n";
                                 silent = true;
                                 action = ":Git<CR>";
                        })
                ];
	};
}
