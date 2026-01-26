{
  description = "CPSC 221 Lab Linked Lists Flake";

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
      env = pkgs.stdenv;
    in {
      default = pkgs.mkShell {
        nativeBuildInputs = with pkgs; [
          clang
          llvm
          gnumake
          bear
          (
            if env.isDarwin
            then lldb
            else gdb
          )
          (
            if env.isLinux
            then valgrind-light
            else null
          )
        ];
        buildInputs = with pkgs; [
          libpng
          zlib
        ];

        shellHook = ''
          export CLANGD_FLAGS="--query-driver=${pkgs.gcc}/bin/g++,${pkgs.clang}/bin/clang++"
          echo "--- Lab Linked Lists Shell Loaded ---"
        '';
      };
    });
  };
}
