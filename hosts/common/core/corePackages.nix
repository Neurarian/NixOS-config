{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    home-manager
    git
    neovim
    age
    wireplumber
    pwvucontrol
    ripgrep
    tio
  ];
}
