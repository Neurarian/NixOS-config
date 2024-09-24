{
  pkgs,
  inputs,
  ...
}:
{

  home.packages = with pkgs; [
    inputs.nixCats.packages.${system}.nixus
  ];

  nixus = {
    enable = true;
  };
}
