{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  # Deps
  numpy,
  scipy,
  natsort,
  tifffile,
  tqdm,
  torch-bin,
  torchvision-bin,
  imagecodecs,
  roifile,
  fastremap,
  fill-voids,
  segment-anything,
  opencv-python-headless,
  # Build system requirements
  setuptools,
  setuptools-scm,
  # Test requirements
  pytestCheckHook,
}:
buildPythonPackage rec {
  pname = "cellpose";
  version = "4.0.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "MouseLand";
    repo = "cellpose";
    tag = "v${version}";
    sha256 = "sha256-V+O+PQ3bWngy8VW9NANoIJ5mYFe9akBaU/HPYkLzyeE=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    numpy
    scipy
    natsort
    tifffile
    tqdm
    # CUDA support only.
    torch-bin
    torchvision-bin
    imagecodecs
    roifile
    fastremap
    fill-voids
    opencv-python-headless
    segment-anything
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  # Disable tests that require home directory access
  disabledTests = [
    # Tests that fail due to /homeless-shelter permission issues
    "test_cellpose_imports_without_error"
    "test_model_zoo_imports_without_error"

    # Tests that try to create files in home directory
    "test_class_2D_one_img"
    "test_class_3D_one_img_shape"
    "test_cli_2D"

    # Shape tests requiring home directory
    "test_shape_2D_grayscale"
    "test_shape_2D_chan_first_diam_resize"
    "test_shape_2D_chan_last"
    "test_shape_2D_2chan_specify"
    "test_shape_stitch"
    "test_shape_3D_2ch"

    # Training tests requiring file system access
    "test_class_train"
    "test_cli_train"
    "test_cli_make_train"

    # Transform tests with file access issues
    "test_normalize_img"
    "test_normalize_img_with_lowhigh_and_invert"
    "test_normalize_img_exceptions"
    "test_resize"
  ];

  pythonImportsCheck = ["cellpose"];

  postPatch = ''
    # Remove pytest-runner from setup requirements
    substituteInPlace setup.py \
      --replace "'pytest-runner'," "" \
  '';

  meta = with lib; {
    description = "Anatomical segmentation algorithm";
    homepage = "https://github.com/mouseland/cellpose";
    license = licenses.bsd3;
    maintainers = [];
  };
}
