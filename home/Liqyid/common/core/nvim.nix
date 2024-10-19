{
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    inputs.nixCats.homeModule
  ];

  home.packages = with pkgs; [
    inputs.nixCats.packages.${system}.nvim
  ];

  nvim = {
    enable = true;
  };
}
