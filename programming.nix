 { config, pkgs, ... }:
{

 environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.

vim
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
