{ config, lib, pkgs, dirtytalkSrc, ... }:

let
vim-dirtytalk = pkgs.vimUtils.buildVimPlugin {
    pname = "vim-dirtytalk";
    version = "source";
    src = dirtytalkSrc;

    nativeBuildInputs = [ pkgs.neovim-unwrapped ];

    postInstall = ''
      mkdir -p $out/spell
      export HOME=$(mktemp -d)

      # Combine all .words files
      cat $out/wordlists/*.words > combined_wordlist.txt

      ${pkgs.neovim-unwrapped}/bin/nvim --headless --clean \
        -c "mkspell! $out/spell/programming combined_wordlist.txt" \
        -c "qall!"
    '';
  };

  cfg = config.programs.nvim-nix.opts.spelling;
in
{
        options.programs.nvim-nix.opts.spelling = {
                dirtytalk = lib.mkOption {
                        type = lib.types.bool;
                        default = true;
                        description = "Enable the programming word list for spellcheck";
                };
        };

        config.vim = lib.mkIf (cfg.enable && cfg.dirtytalk) {
                spellcheck.languages = ["programming"];

                startPlugins = [vim-dirtytalk];
        };
}
