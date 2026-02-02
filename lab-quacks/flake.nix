{
  description = "CPSC 221 Lab Quacks Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
  }: let
    # "aarch64-darwin" not supported:
    # testing framework used published in 2019,
    # while M-chips were released in 2020.
    supportedSystems = ["x86_64-linux" "aarch64-linux" "x86_64-darwin"];
    forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    nixpkgsFor = forAllSystems (system: import nixpkgs {inherit system;});
  in {
    devShells = forAllSystems (system: let
      pkgs = nixpkgsFor.${system};
      env = pkgs.stdenv;
      mkbear = pkgs.writeShellScriptBin "mkbear" "bear -- make --always-make --keep-going --silent";
    in {
      default = pkgs.mkShell {
        nativeBuildInputs = with pkgs; [
          clang
          gnumake
          (
            if env.isDarwin
            then lldb
            else gdb
          )
          bear
          mkbear
          (
            if env.isLinux
            then valgrind-light
            else null
          )
        ];
        buildInputs = with pkgs; [
        ];

        shellHook = ''
          export CLANGD_FLAGS="--query-driver=${pkgs.clang}/bin/clang++"
          echo "--- Lab Quacks Shell Loaded ---"
        '';
      };
    });
  };
}
