{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pytestCheckHook,
}:
buildPythonPackage rec {
  pname = "segment_anything";
  version = "1.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-7Qyfb7B7vvnGI4pwKKE8gnLxumtjBcpz4+BkJmUDc2s=";
  };

  build-system = [
    setuptools
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  doCheck = false;

  meta = with lib; {
    description = "Segment Anything Model";
    homepage = "https://github.com/facebookresearch/segment-anything";
    maintainers = [];
  };
}
