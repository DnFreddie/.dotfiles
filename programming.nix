 { config, pkgs, ... }:
{

 environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.

wget
shellcheck
turso-cli
jdk
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
