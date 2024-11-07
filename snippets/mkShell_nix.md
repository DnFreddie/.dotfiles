---
date: "2024-07-22T09:10:24+02:00"
draft: false
title: mkShell nix
---

``` nix
{
pkgs ? import<nixpkgs>{}
}:

pkgs.mkShell{
pacages: with pkgs; [
nodejs
];
}
```
