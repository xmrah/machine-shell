#!/usr/bin/env bash
set -e

echo "🚀 Machine Shell – Kurulum başlıyor..."

ZSHRC="$HOME/.zshrc"
MACHINE_DIR="$HOME/.config/machine-shell"
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if [[ -f "$ZSHRC" ]]; then
  backup="$ZSHRC.backup.$(date +%Y%m%d-%H%M%S)"
  echo "🔁 Mevcut .zshrc bulundu, yedekleniyor -> $backup"
  cp "$ZSHRC" "$backup"
fi

mkdir -p "$MACHINE_DIR"

echo "📁 Çekirdek dosyalar kopyalanıyor..."
cp "$REPO_DIR/zsh/core.zsh"    "$MACHINE_DIR/core.zsh"
cp "$REPO_DIR/zsh/prompt.zsh"  "$MACHINE_DIR/prompt.zsh"
cp "$REPO_DIR/zsh/aliases.zsh" "$MACHINE_DIR/aliases.zsh"

echo "🧠 .zshrc loader kuruluyor..."
cp "$REPO_DIR/zsh/zshrc.machine" "$ZSHRC"

echo
echo "✅ Kurulum tamam."
echo "  1) Zsh varsayılan değilse:  chsh -s /bin/zsh"
echo "  2) Yeni bir terminal aç."
echo
echo "Machine Shell Core v1 aktif."
