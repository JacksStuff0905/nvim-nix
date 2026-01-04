{config, lib, ...}:
let
        cfg = config.programs.nvim-nix.global-keymaps;
in
{
        # Configure global keymaps here.
        # If a keymap is used for a plugin, it should be placed in the plugin's config instead.

        options.programs.nvim-nix.global-keymaps = {
                enable = lib.mkEnableOption "Enable global keymaps module";

                window-navigation = {
                        enable = lib.mkOption { type = lib.types.bool; default = true; };

                        left = lib.mkOption { type = lib.types.str; default = "H"; };
                        right = lib.mkOption { type = lib.types.str; default = "L"; };
                        down = lib.mkOption { type = lib.types.str; default = "J"; };
                        up = lib.mkOption { type = lib.types.str; default = "K"; };

                        previous = lib.mkOption { type = lib.types.str; default = "<leader>bk"; };
                        next = lib.mkOption { type = lib.types.str; default = "<leader>fw"; };
                };

                search-highlighting = {
                        enable = lib.mkOption { type = lib.types.bool; default = true; };

                        key = lib.mkOption { type = lib.types.str; default = "<leader>nh"; };
                };
        };


        config.vim.keymaps = lib.mkIf cfg.enable (lib.mkMerge [
                # Configure window navigation
                (lib.mkIf cfg.window-navigation.enable [
                        { key = cfg.window-navigation.left; mode = "n"; action = "<C-w>h"; }
                        { key = cfg.window-navigation.down; mode = "n"; action = "<C-w>j"; }
                        { key = cfg.window-navigation.up; mode = "n"; action = "<C-w>k"; }
                        { key = cfg.window-navigation.right; mode = "n"; action = "<C-w>l"; }

                        { key = cfg.window-navigation.previous; mode = "n"; action = "<C-o>"; }
                        { key = cfg.window-navigation.next; mode = "n"; action = "<C-i>"; }
                ])

                # Configure seach highlighting
                (lib.mkIf cfg.search-highlighting.enable [
                        { key = cfg.search-highlighting.key; mode = "n"; action = ":noh<CR>"; }
                ])
        ]);
}
