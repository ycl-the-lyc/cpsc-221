{
  description = "CPSC 221 Lab Heaps";

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
          compiledb
          gnumake
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
        ];

        shellHook = ''
          export CLANGD_FLAGS="--query-driver=${pkgs.gcc}/bin/g++,${pkgs.clang}/bin/clang++"
        '';
      };
    });
  };
}
