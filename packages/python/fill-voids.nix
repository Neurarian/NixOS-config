{
  lib,
  buildPythonPackage,
  fetchPypi,
  numpy,
  fastremap,
  cython,
  pbr,
  setuptools,
  # Test requirements
  pytestCheckHook,
}:
buildPythonPackage rec {
  pname = "fill_voids";
  version = "2.1.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Rp9UPkqyNs8Rqs7xBq+Oc8cw8qkPG/rnYNyN4p1NZjQ=";
  };

  propagatedBuildInputs = [
    numpy
    fastremap
  ];

  build-system = [
    setuptools
    cython
    pbr
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];
  doCheck = false;
  # pythonImportsCheck = ["fill_voids"];

  meta = with lib; {
    description = "Fill holes in binary 2D & 3D images fast.";
    homepage = "https://github.com/seung-lab/fill_voids/";
    license = licenses.lgpl3;
    maintainers = [];
  };
}
