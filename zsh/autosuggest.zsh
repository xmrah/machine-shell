# autosuggest.zsh – Machine Shell Autosuggestions v1
# Gereksinim: pacman -S zsh-autosuggestions

# Sadece interaktif shell'de çalışsın
[[ -o interactive ]] || return 0

# Plugin dosyasını bul
if [[ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
  source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
else
  # Bulunamazsa sessizce çık, terminal çökmeyecek
  return 0
fi

# Stil ayarı – gri hayalet gibi olsun, gözü yormasın
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'

# Performans ayarı – sadece history'den öner, komut gecikmesin
ZSH_AUTOSUGGEST_STRATEGY=(history)

# Çok hızlı yazarken saçmalamasın diye:
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=200
