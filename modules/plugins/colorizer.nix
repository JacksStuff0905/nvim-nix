{config, lib, pkgs, ...}:
let
        cfg = config.programs.nvim-nix.plugins.colorizer;
in
{
        options.programs.nvim-nix.plugins.colorizer = {
                enable = lib.mkEnableOption "Enable colorizer plugin module";

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
                                               print("testest")
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
