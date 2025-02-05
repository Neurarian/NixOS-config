# "Significance Analysis of INTeractome (SAINT) is a statistical method for probabilistically scoring protein-protein interaction data from affinity purification-mass spectrometry (AP-MS) experiments."
# PMID: 24513533
{
  stdenv,
  fetchurl,
  autoPatchelfHook,
}:
stdenv.mkDerivation {
  name = "saint";
  src = fetchurl {
    url = "https://downloads.sourceforge.net/project/saint-apms/SAINTexpress_v3.6.3__2018-03-09.tar.gz";
    hash = "sha256-Zo2tovNhe8m7iZMUwJe9Qanej5vteOk0RZzBJRJrFII=";
  };
  nativeBuildInputs = [autoPatchelfHook];
  buildInputs = [stdenv.cc.cc.lib];

  unpackPhase = ''
    tar xf $src
    ls -la
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp */Precompiled_binaries/Linux64/SAINTexpress-spc $out/bin/
    cp */Precompiled_binaries/Linux64/SAINTexpress-int $out/bin/
  '';
}
