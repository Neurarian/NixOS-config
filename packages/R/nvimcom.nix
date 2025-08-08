{
  rPackages,
  R,
  gcc,
  gnumake,
  rNvim,
}:
rPackages.buildRPackage {
  name = "nvimcom";
  src = rNvim;
  sourceRoot = "source/nvimcom";

  buildInputs = [
    R
    gcc
    gnumake
  ];

  meta = {
    description = "R.nvim communication package";
    homepage = "https://github.com/R-nvim/R.nvim";
    maintainers = [];
  };
}
