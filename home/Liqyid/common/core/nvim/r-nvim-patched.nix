{
  stdenv,
  rNvim,
}:
stdenv.mkDerivation {
  pname = "R-nvim-patched";
  version = "unstable";
  src = rNvim;
  buildPhase = ''
    make -C rnvimserver
  '';
  installPhase = ''
    mkdir -p $out
    cp -r . $out/
  '';
}
