{ pkgs, ... }:
{
  fonts.packages = with pkgs; [
    fira-code
    jetbrains-mono
    material-symbols
    (nerdfonts.override {
      fonts = [
        "FiraCode"
        "JetBrainsMono"
        "NerdFontsSymbolsOnly"
      ];
    })
  ];
}
