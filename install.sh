#!/bin/bash
set -e # Keluar jika ada perintah yang gagal

echo "Memulai instalasi NVM dan Flutter di non-interactive shell..."

# --- Instalasi NVM ---
echo "--- Memulai instalasi NVM ---"
export NVM_DIR="$HOME/.nvm"
mkdir -p "$NVM_DIR" || { echo "Gagal membuat direktori NVM"; exit 1; }
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash || { echo "Gagal menjalankan script instalasi NVM"; exit 1; }

# Inisialisasi NVM untuk session saat ini
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" || { echo "Gagal menginisialisasi NVM (nvm.sh)"; exit 1; }
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" || { echo "Gagal menginisialisasi NVM (bash_completion)"; exit 1; }

nvm --version || { echo "NVM gagal diinstal atau diinisialisasi"; exit 1; }
nvm install --lts || { echo "Gagal menginstal Node.js LTS"; exit 1; }
nvm use --lts || { echo "Gagal mengaktifkan Node.js LTS"; exit 1; }
nvm alias default --lts
node -v || { echo "Node.js tidak terinstal atau tidak ditemukan"; exit 1; }
npm -v || { echo "NPM tidak terinstal atau tidak ditemukan"; exit 1; }
echo "--- Instalasi NVM dan Node.js berhasil ---"

# --- Instalasi Flutter ---
echo "--- Memulai instalasi Flutter ---"
FLUTTER_INSTALL_DIR="$HOME/flutter_sdk"
FLUTTER_SDK_URL="https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.22.2-stable.tar.xz" # Ganti dengan URL terbaru dan sesuai OS
FLUTTER_ARCHIVE_NAME=$(basename "$FLUTTER_SDK_URL")

mkdir -p "$FLUTTER_INSTALL_DIR" || { echo "Gagal membuat direktori Flutter"; exit 1; }
curl -o "$FLUTTER_INSTALL_DIR/$FLUTTER_ARCHIVE_NAME" "$FLUTTER_SDK_URL" || { echo "Gagal mengunduh Flutter SDK"; exit 1; }
tar -xf "$FLUTTER_INSTALL_DIR/$FLUTTER_ARCHIVE_NAME" -C "$FLUTTER_INSTALL_DIR" || { echo "Gagal mengekstrak Flutter SDK"; exit 1; }

export PATH="$PATH:$FLUTTER_INSTALL_DIR/flutter/bin"

flutter --version || { echo "Flutter gagal diinstal atau tidak ditemukan di PATH"; exit 1; }
# Penting: menerima lisensi Android secara otomatis
flutter doctor --android-licenses --drd || { echo "Flutter doctor --android-licenses gagal"; exit 1; }
flutter doctor -v || { echo "Flutter doctor gagal"; exit 1; }

echo "--- Instalasi Flutter berhasil ---"

echo "Instalasi NVM dan Flutter selesai."
