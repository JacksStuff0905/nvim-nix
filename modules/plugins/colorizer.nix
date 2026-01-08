{config, lib, pkgs, ...}:
let
        name = "colorizer";

        cfg = config.nvim-nix.plugins.${name};
in
{
        options.nvim-nix.plugins.${name} = {
                enable = lib.mkEnableOption "Enable ${name} plugin module";

                auto-attach = lib.mkOption {
                        type = lib.types.bool;
                        default = true;
                };

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
                                        default = "<leader>cl";
                                };
                        };
                };
        };

	config.vim = lib.mkIf cfg.enable {
		ui.colorizer = {
                        enable = true;
                        setupOpts = {
                                filetypes = {
                                        "*" = { /* Option overrides */ };
                                };
                        };
                };

                # Configure auto attach to buffer
                autocmds = lib.mkIf cfg.auto-attach [
                        {
                               event = [ "BufReadPost" "BufNewFile" ];
                               callback = lib.generators.mkLuaInline ''
                                       function()
                                               require("colorizer").attach_to_buffer(0)
                                       end
                               '';
                        }      
                ];

                # Keybinds
                keymaps = lib.mkIf cfg.keymaps.enable [
                        (lib.mkIf cfg.keymaps.toggle.enable {
                                 key = cfg.keymaps.toggle.key;
                                 mode = "n";
                                 silent = true;
                                 action = ":ColorizerToggle<CR>";
                        })
                ];
	};
}
