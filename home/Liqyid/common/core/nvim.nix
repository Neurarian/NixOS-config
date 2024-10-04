{
  pkgs,
  inputs,
  ...
}:
{

  home.packages = with pkgs; [
    inputs.nixCats.packages.${system}.nvim
  ];

  nvim = {
    enable = true;
  };
}
