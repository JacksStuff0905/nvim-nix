{config, lib, pkgs, ...}:
let
        cfg = config.programs.nvim-nix.themes;
in
{
        options.programs.nvim-nix.themes = {
                enable = lib.mkEnableOption "Enable theme managment module";
                
                # This value will be automatically set if using either the HM or NixOS module
                system-theme = lib.mkOption {
                        type = lib.types.str;
                        internal = true;
                };
                
        };
}
