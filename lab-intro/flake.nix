{
  description = "CPSC Lab Intro Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
  }: let
    supportedSystems = ["x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin"];
    forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    nixpkgsFor = forAllSystems (system: import nixpkgs {inherit system;});
  in {
    devShells = forAllSystems (system: let
      pkgs = nixpkgsFor.${system};
    in {
      default = pkgs.mkShell {
        nativeBuildInputs = with pkgs; [
          gcc
          gnumake
          gdb
          bear
        ];
        buildInputs = with pkgs; [
          libpng
          zlib
        ];

        shellHook = ''
          export CLANGD_FLAGS="--query-driver=${pkgs.gcc}/bin/g++,${pkgs.clang}/bin/clang++"
          bear -- make --always-make --keep-going --silent
          make clean
          echo "--- Lab Intro Shell Loaded ---"
        '';
      };
    });
  };
}
