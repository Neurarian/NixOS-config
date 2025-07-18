{
  lib,
  buildPythonPackage,
  fetchPypi,
  # Dependencies for roifile
  numpy,
  tifffile,
  #matplotlib,
  setuptools,
  # Test requirements
  pytestCheckHook,
}:
buildPythonPackage rec {
  pname = "roifile";
  version = "2025.5.10";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-jl0feZaVrFn1LU1iu5AW3nTvJJO02D4kzn+yXhn1PM4=";
  };

  dependencies = [
    numpy
    tifffile
    #matplotlib
  ];

  build-system = [
    setuptools
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  doCheck = false;
  #pythonImportsCheck = [ "roifile" ];

  meta = with lib; {
    description = "Read and write ImageJ ROI format";
    homepage = "https://github.com/cgohlke/roifile";
    license = licenses.bsd3;
    maintainers = [];
  };
}
