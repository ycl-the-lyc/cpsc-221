# CPSC 221
A setup for the UBC_V CPSC 211 course. No solution included.

It uses Nix to manage dependencies, and Nix dev shell or Nix-direnv to setup the environment.

## Requirements
- `nix` with flake enabled
- `direnv` and `nix-direnv` (optional)

## Usage
1. Clone the repo; put actual material, like the unzipped `lab_intro` source, into corresponding directories.
2. `cd` into speficic directories, like `lab-0` (Lab Intro).
3. Without `nix-direnv`, modify or remove `.envrc`; without `direnv`, remove `.envrc`.
4. With `direnv` and `nix-direnv`, wait for it to setup; without them, `nix develop` to enter the dev shell.

