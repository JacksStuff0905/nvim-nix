{
  config,
  lib,
  pkgs,
  ...
}:
let
  name = "undotree";

  cfg = config.programs.nvim-nix.plugins.${name};
in
{
  options.programs.nvim-nix.plugins.${name} = {
    enable = lib.mkEnableOption "Enable ${name} plugin module";

    layout = {
      tree = lib.mkOption {
        type = lib.types.enum [
          "left"
          "right"
        ];
        default = "right";
      };
      diff = lib.mkOption {
        type = lib.types.enum [
          "attached"
          "bottom"
        ];
        default = "attached";
      };
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
          default = "<leader>ut";
        };
      };
    };
  };

  config.vim = lib.mkIf cfg.enable {
    # Extra dependencies
    extraPackages = with pkgs; [
      diffutils
    ];

    utility.undotree = {
      enable = true;
    };

    globals = {
      undotree_WindowLayout =
        if (cfg.layout.tree == "left") then
          if (cfg.layout.diff == "attached") then 1 else 2
        else if (cfg.layout.diff == "attached") then
          3
        else
          4;
    };

    # Keybinds
    keymaps = lib.mkIf cfg.keymaps.enable [
      (lib.mkIf cfg.keymaps.toggle.enable {
        key = cfg.keymaps.toggle.key;
        mode = "n";
        silent = true;
        action = ":UndotreeToggle<CR>";
      })
    ];
  };
}
