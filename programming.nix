 { config, pkgs, ... }:
{

 environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.

vim
libvirt
(python3.withPackages(ps: with ps; [ libvirt  pynvim ansible lxml ansible-core]))
wget
shellcheck
turso-cli
gradle
nodejs
neovim
go
rustup
gcc
clang
chromium
### Golang
air
  ];
  
}
