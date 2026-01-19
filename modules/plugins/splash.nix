{
  config,
  lib,
  pkgs,
  ...
}:
let
  name = "splash";

  cfg = config.programs.nvim-nix.plugins.${name};
in
{
  options.programs.nvim-nix.plugins.${name} = {
    enable = lib.mkEnableOption "Enable ${name} plugin module";

    theme = lib.mkOption {
      type = lib.types.enum [
        "dashboard"
        "startify"
        "theta"
      ];
      default = "startify";
    };
  };

  config.vim = lib.mkIf cfg.enable {
    dashboard.alpha = {
      enable = true;
      theme = cfg.theme;
    };

    lazy.plugins."mini.icons" = {
      package = pkgs.vimPlugins.mini-icons;
    };
  };
}
