# highlight.zsh – Machine Shell Syntax Highlighting v1
# Gereksinim: pacman -S zsh-syntax-highlighting

# Sadece interaktif shell'de çalışsın
[[ -o interactive ]] || return 0

# Plugin dosyasını bul ve yükle
if [[ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
  source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
else
  return 0
fi

# Bu plugin genelde en sonda yüklenmeli.
# Renkleri sonra özelleştirebiliriz, şimdilik default tema.
