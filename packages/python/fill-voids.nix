{
  lib,
  buildPythonPackage,
  fetchPypi,
  # Dependencies for roifile
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
  version = "2.1.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Y/dvfb3Yy18w6ihBoxYk66RhLZEhHW/3TSMX9E1EmGA=";
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
