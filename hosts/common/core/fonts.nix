{pkgs, ...}: {
  fonts.packages = with pkgs; [
    fira-code
    jetbrains-mono
    material-symbols
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
    nerd-fonts.symbols-only
  ];
}
