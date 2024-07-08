 { config, pkgs, ... }:
{

 environment.systemPackages = with pkgs; [

vim
(python3.withPackages(ps: with ps; [ libvirt  pynvim ansible lxml ansible-core docker ]))
wget
shellcheck
turso-cli
nodejs
neovim
gcc
poetry
clang
rustup
### Golang
go
zig
dmidecode
libgcc
cmake
air
  ];
  
}
