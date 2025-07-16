{pkgs}: let
  pythonEnv = pkgs.python311.withPackages (ps:
    with ps; [
      pip
      setuptools
      wheel
    ]);
in
  pkgs.mkShell {
    buildInputs = with pkgs; [
      pythonEnv
      pkg-config
      stdenv.cc.cc.lib
      glibc
    ];

    shellHook = ''
      export VENV_DIR="$HOME/.cache/nix-shells/cellpose-venv"

      # Only create venv if it doesn't exist
      if [ ! -d "$VENV_DIR" ]; then
        echo "🔧 Creating new virtual environment..."
        python -m venv "$VENV_DIR"
      fi

      source "$VENV_DIR/bin/activate"
      export LD_LIBRARY_PATH="/usr/lib/wsl/lib:${pkgs.stdenv.cc.cc.lib}/lib:${pkgs.glibc}/lib:$LD_LIBRARY_PATH"

      # Check if PyTorch is already installed
      if ! python -c "import torch" 2>/dev/null; then
        echo "🔧 Select PyTorch CUDA version to install:"
        echo "  118  - CUDA 11.8"
        echo "  126  - CUDA 12.6"
        echo "  128  - CUDA 12.8"
        echo "  rocm6.3 - ROCm 6.3"
        echo "  cpu  - CPU only"
        echo ""
        echo -n "Enter your choice [default: 128]: "
        read version

        if [ -z "$version" ]; then
          version="128"
        fi

        case $version in
          118|126|128)
            pytorch_url="https://download.pytorch.org/whl/cu$version"
            echo "Selected: CUDA $version"
            ;;
          rocm6.3)
            pytorch_url="https://download.pytorch.org/whl/rocm6.3"
            echo "Selected: ROCm 6.3"
            ;;
          cpu)
            pytorch_url="https://download.pytorch.org/whl/cpu"
            echo "Selected: CPU only"
            ;;
          *)
            echo "Invalid version '$version', defaulting to CUDA 12.8"
            pytorch_url="https://download.pytorch.org/whl/cu128"
            ;;
        esac

        pip install --upgrade pip
        echo "Installing PyTorch from: $pytorch_url"
        pip install torch torchvision torchaudio --index-url $pytorch_url
        pip install cellpose
      else
        echo "✅ PyTorch already installed, skipping installation"
      fi

      export CELLPOSE_LOCAL_MODELS_PATH="$HOME/.cellpose/models"

      echo ""
      echo "🔬 Cellpose environment ready!"
      echo "PyTorch version: $(python -c "import torch; print(torch.__version__)")"
      echo "GPU acceleration: $(python -c "import torch; print('Available' if torch.cuda.is_available() else 'Not available')")"
      echo ""
      echo "Available commands:"
      echo "  python -m cellpose --help   # See CLI options"
    '';
  }
