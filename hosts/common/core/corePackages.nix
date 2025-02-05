{pkgs, ...}: {
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
  programs.zsh.enable = true;
  environment.shells = [pkgs.zsh];
}
