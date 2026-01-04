{config, lib, pkgs, ...}:
let
        default = val: lib.mkOverride 1001 val;
in
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
                        enable = default true;
                };

                plugins = {
                        neo-tree.enable = default true;
                        colorizer.enable = default true;
                };

                languages = {
                        enable = default true;
                };
        };
}
