{
  rPackages,
  R,
  gcc,
  gnumake,
  rNvim,
}:
rPackages.buildRPackage {
  pname = "nvimcom";
  src = rNvim;
  sourceRoot = "source/nvimcom";
  version = "0.1";

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
