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
    # Detect WSL and apply workaround conditionally. Otherwise gets deadlocked at ROI saving.
    if [[ -f /proc/version ]] && grep -qi microsoft /proc/version; then
      export LD_LIBRARY_PATH="/usr/lib/wsl/lib:/lib:$LD_LIBRARY_PATH"
      echo "🔧 WSL detected - applying multiprocessing workaround"
      export OMP_NUM_THREADS=1
      echo "⚠️  WSL compatibility mode: multiprocessing disabled"
    else
      echo "🚀 Native Linux detected - multiprocessing enabled"
    fi

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
