{...}:

let
  file_to_not_import = [
    "default.nix"
  ];

  get-import-dir = dir: ignore: import ./util/get-import-dir.nix {lib = nixpkgs.lib; inherit dir; inherit ignore;};
in
{
  imports = get-import-dir ./. file_to_not_import;
}
