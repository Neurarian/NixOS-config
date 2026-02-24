{pkgs}:
pkgs.mkShell {
  buildInputs = with pkgs; [
    stdenv.cc.cc.lib
    glibc
    cellpose
    cudatoolkit
    cudaPackages.cudnn
  ];

  shellHook = ''
    export CELLPOSE_LOCAL_MODELS_PATH="$HOME/.cellpose/models"

    echo ""
    echo "🔬 Cellpose environment ready!"
    echo "PyTorch version: $(python -c "import torch; print(torch.__version__)")"
    echo "GPU acceleration: $(python -c "import torch; print('Available' if torch.cuda.is_available() else 'Not available')")"
    echo ""
    echo "Available commands:"
    echo "  cellpose --help   # See CLI options"
    echo "  cellpose          # Launch cellpose GUI"
  '';
}
