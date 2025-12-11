# analytics.zsh – Machine Shell Error & Risk Brain v1

MS_HISTORY_FILE="${MS_HISTORY_FILE:-$HOME/.local/share/machine-shell/history.log}"

_ms_check_log() {
  if [[ ! -f "$MS_HISTORY_FILE" ]]; then
    echo "History log yok: $MS_HISTORY_FILE"
    return 1
  fi
}

# Son hatalı komutlar
ms-fails() {
  _ms_check_log || return 1

  echo "===== MACHINE-SHELL – SON HATALI KOMUTLAR ====="
  # format: timestamp|cwd|exit|command
  awk -F'|' '$3 != 0 {print $1 "  [" $3 "]  " $4}' "$MS_HISTORY_FILE" \
    | tail -n 20
}

# Riskli komutlar (rm -rf, sudo, pacman -Syu vb)
ms-risk() {
  _ms_check_log || return 1

  echo "===== MACHINE-SHELL – RİSKLİ KOMUTLAR ====="
  grep -E 'rm -rf|sudo|pacman -Syu' "$MS_HISTORY_FILE" \
    | awk -F'|' '{print $1 "  " $4}' \
    | tail -n 30
}

# Bugünün özeti
ms-today() {
  _ms_check_log || return 1

  local today total fails
  today=$(date +%Y-%m-%d)

  total=$(grep "^$today" "$MS_HISTORY_FILE" | wc -l)
  fails=$(grep "^$today" "$MS_HISTORY_FILE" | awk -F'|' '$3 != 0' | wc -l)

  echo "===== MACHINE-SHELL – BUGÜN ÖZET ====="
  echo "Tarih          : $today"
  echo "Toplam komut   : $total"
  echo "Hatalı komut   : $fails"
}

# Genel özet
ms-summary() {
  _ms_check_log || return 1

  echo "===== MACHINE-SHELL – GENEL ÖZET ====="

  echo "- Toplam komut:"
  awk -F'|' '{c++} END {print "  " c+0}' "$MS_HISTORY_FILE"

  echo "- Toplam hatalı:"
  awk -F'|' '$3 != 0 {c++} END {print "  " c+0}' "$MS_HISTORY_FILE"

  echo "- En sık kullanılan 10 komut:"
  awk -F'|' '{print $4}' "$MS_HISTORY_FILE" \
    | sed '/^$/d' \
    | sort \
    | uniq -c \
    | sort -nr \
    | head -n 10 \
    | sed 's/^/  /'
}
