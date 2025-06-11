#!/bin/bash

# Script ini menginstal Flutter SDK di Linux dan mengkonfigurasi PATH.

echo "Memulai instalasi Flutter di Linux..."

# 1. Menginstal paket yang diperlukan untuk pengembangan Flutter
echo "Memperbarui daftar paket dan menginstal dependensi dasar..."
sudo apt-get update -y && sudo apt-get upgrade -y
sudo apt-get install -y curl git unzip xz-utils zip libglu1-mesa

# 2. Menginstal paket prasyarat untuk pengembangan aplikasi Android (opsional, tetapi direkomendasikan)
echo "Menginstal dependensi Android Studio..."
sudo apt-get install -y libc6:amd64 libstdc++6:amd64 lib32z1 libbz2-1.0:amd64

# Catatan: Instalasi Android Studio penuh harus dilakukan secara manual setelah ini.
# Flutter membutuhkan Android Studio versi lengkap untuk debug dan kompilasi kode Java atau Kotlin untuk Android.

# 3. Mengunduh dan menginstal Flutter SDK
echo "Mengunduh Flutter SDK versi stabil terbaru..."
FLUTTER_SDK_URL="https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.32.2-stable.tar.xz"
DOWNLOAD_DIR="$HOME/Downloads"
INSTALL_DIR="$HOME/development"
FLUTTER_ARCHIVE="$DOWNLOAD_DIR/flutter_linux_3.32.2-stable.tar.xz"
FLUTTER_PATH="$INSTALL_DIR/flutter"

mkdir -p "$INSTALL_DIR" # Membuat direktori pengembangan jika belum ada

# Menggunakan curl untuk mengunduh Flutter SDK
curl -L -o "$FLUTTER_ARCHIVE" "$FLUTTER_SDK_URL" || { echo "Gagal mengunduh Flutter SDK."; exit 1; }

echo "Mengekstrak Flutter SDK ke $INSTALL_DIR..."
tar -xf "$FLUTTER_ARCHIVE" -C "$INSTALL_DIR/" || { echo "Gagal mengekstrak Flutter SDK."; exit 1; }

# Menghapus file arsip setelah ekstraksi
rm "$FLUTTER_ARCHIVE"

echo "Flutter SDK telah berhasil diinstal di $FLUTTER_PATH"

# 4. Menambahkan Flutter ke PATH
echo "Menambahkan Flutter ke variabel lingkungan PATH..."

# Mendeteksi shell default
DEFAULT_SHELL=$(basename "$SHELL")
SHELL_RC_FILE=""

case "$DEFAULT_SHELL" in
    "bash")
        SHELL_RC_FILE="$HOME/.bash_profile"
        if [ ! -f "$SHELL_RC_FILE" ]; then
            SHELL_RC_FILE="$HOME/.bashrc"
        fi
        ;;
    "zsh")
        SHELL_RC_FILE="$HOME/.zshrc"
        ;;
    *)
        echo "Shell default Anda ($DEFAULT_SHELL) tidak didukung secara otomatis untuk konfigurasi PATH."
        echo "Anda perlu menambahkan baris berikut ke file konfigurasi shell Anda secara manual:"
        echo "export PATH=\"$FLUTTER_PATH/bin:\$PATH\""
        echo "Silakan merujuk ke dokumentasi shell Anda untuk informasi lebih lanjut."
        ;;
esac

if [ -n "$SHELL_RC_FILE" ]; then
    if grep -q "export PATH=\"\$HOME/development/flutter/bin:\$PATH\"" "$SHELL_RC_FILE"; then
        echo "Flutter PATH sudah ada di $SHELL_RC_FILE. Melewati penambahan."
    else
        echo "export PATH=\"$FLUTTER_PATH/bin:\$PATH\"" >> "$SHELL_RC_FILE"
        echo "PATH Flutter telah ditambahkan ke $SHELL_RC_FILE."
        echo "Harap muat ulang shell Anda (misalnya, dengan menjalankan 'source $SHELL_RC_FILE' atau membuka jendela terminal baru) agar perubahan PATH berlaku."
    fi
fi

echo "Instalasi Flutter selesai!"
echo "Untuk memverifikasi instalasi, jalankan 'flutter doctor' di terminal baru."
