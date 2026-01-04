{config, lib, pkgs, ...}:
{
        imports = [
                ./full.nix
                ./basic.nix
        ];

        options.programs.nvim-nix.profile = lib.mkOption {
                type = lib.types.enum [ "basic" "full" ];
                default = "basic";
        };


        config.programs.nvim-nix = {
                opts = {
                        enable = lib.mkDefault true;
                };

                plugins = {
                        neo-tree.enable = lib.mkDefault true;
                };

                languages = {
                        enable = true;
                };
        };
}
