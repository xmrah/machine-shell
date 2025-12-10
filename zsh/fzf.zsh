# fzf.zsh – Machine Shell Fuzzy Tools v1
# Gereksinim: fzf paketi (pacman -S fzf)

# Sadece interaktif shell'de çalışsın
[[ -o interactive ]] || return 0

# fzf yoksa sessizce çık
if ! command -v fzf >/dev/null 2>&1; then
  return 0
fi

# ================
# Fuzzy history (fh)
# ================
# Kullanım:
#   fh      → fzf ile history seç, komutu satıra yaz
#   Ctrl+R  → aynı işi widget gibi yap

fh() {
  # Tüm history'yi numaralarıyla çek
  # Örnek satır: " 123  pacman -Syu"
  local selected
  selected=$(
    fc -ln 1 \
    | nl -ba \
    | fzf --reverse --tac --prompt="history> " --bind='enter:accept' \
          --header="↑/↓: gezin, yaz: filtrele, enter: komutu seç" \
  ) || return 1

  # Baştaki numarayı strip et, sadece komutu al
  selected=${selected##*[0-9] }
  print -r -- "$selected"
}

# ================
# Ctrl+R için zle widget
# ================
_ms_fzf_history_widget() {
  emulate -L zsh
  local cmd
  cmd=$(fh) || return
  LBUFFER="$cmd"
  RBUFFER=""
  zle redisplay
}
zle -N _ms_fzf_history_widget

# Ctrl+R → fzf history
bindkey '^R' _ms_fzf_history_widget
