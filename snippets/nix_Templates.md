---
date: "2024-07-22T09:10:24+02:00"
draft: false
title: nix Templates
---

## For python project

*Remember to add poetry.lock to the repo* *Propably need to replace ./.
with self*

``` nix
 {
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs = { self, nixpkgs }:
    let
      supportedSystems = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];
      forAllSystems: nixpkgs.lib.genAttrs supportedSystems;
      pkgs: forAllSystems (system: nixpkgs.legacyPackages.${system});
    in
    {
      packages: forAllSystems (system: {
        default: pkgs.${system}.poetry2nix.mkPoetryApplication { projectDir = ./.; };
      });

      devShells: forAllSystems (system: {
        default: pkgs.${system}.mkShellNoCC {
          packages: with pkgs.${system}; [
            (poetry2nix.mkPoetryEnv { projectDir = ./.; })
            poetry
            go
            chromium
          ];
        };
      });

    };
}
```

------------------------------------------------------------------------

[nix](/Notes/posts/nix)
[flake](/Notes/posts/code_snippets/flake)[SNIPPETS_MAIN](/Notes/posts/SNIPPETS_MAIN)
