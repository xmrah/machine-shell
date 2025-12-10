# Machine Shell – Aliases v1
# Buraya sadece sık kullandığın, güvenli kısayollar gelecek.

# ls ailesi
alias ls='ls --color=auto'
alias ll='ls -lh'
alias la='ls -lha'

# Genel
alias c='clear'
alias e='nano'

# Sistem / paket yöneticisi (Artix/Arch)
alias update='sudo pacman -Syu'
alias up='sudo pacman -Syu'

# grep renkli
alias grep='grep --color=auto'

# Git kısayolları (ileride daha da genişletebiliriz)
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline --graph --decorate'



# ========= Machine Shell Help =========

ms_help() {
  cat <<'EOF'
🧠 Machine Shell v0.1 — xmrah Edition

Mevcut modüller:
  • core.zsh       → Zsh çekirdek ayarları (history, PATH, setopt)
  • prompt.zsh     → 2 satırlı sade prompt (kullanıcı@makine ~/klasör)
  • aliases.zsh    → ls/ll/la, git alias'ları, update vs.
  • telemetry.zsh  → history.log, stats, theat (günlük komut sayısı)
  • safety.zsh     → rm koruması, risk skoru, safety.log
  • ai.zsh         → AI köprüsü için iskelet (şu an devre dışı)

Hatırlatıcı komutlar:
  • stats          → En çok kullandığın komutlar (top 10)
  • theat          → Günlük kaç komut çalıştırdın (heatmap)
  • askai          → AI devre dışı mesajı (ileride LM Studio entegrasyonu)
  • ms             → Bu ekran (help/cheat sheet)

Log dosyaları:
  • ~/.local/share/machine-shell/history.log
  • ~/.local/share/machine-shell/safety.log

Not: Şu an LAB modundasın (zsh -f + manual source). 
Install aşamasında bu modüller ~/.config/machine-shell altına taşınacak.
EOF
}

alias ms='ms_help'
