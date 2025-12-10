# telemetry.zsh – Machine Shell Telemetry v2
# Görev: Komutları logla, istatistik çıkar, history'yi okunur yap.

# =========================
# Log dosyası yolu
# =========================

# Eğer dışarıdan override edilmediyse, default değer:
: ${MACHINE_SHELL_HISTORY_FILE:="$HOME/.local/share/machine-shell/history.log"}

# Dizini oluştur (dosya değil, sadece klasörü)
if [[ -n "$MACHINE_SHELL_HISTORY_FILE" ]]; then
  mkdir -p "${MACHINE_SHELL_HISTORY_FILE:h}"
fi

# =========================
# precmd hook: her komuttan sonra log
# =========================
# Format:
# 2025-12-10T19:16:25|/home/user/machine-shell|0|ls

_ms_telemetry_precmd() {
  # Son komutun çıkış kodu
  local exit_code=$?

  # Son komut (history'den çek)
  local cmd
  cmd=$(fc -ln -1 | sed 's/^[[:space:]]*//')
  [[ -z "$cmd" ]] && return 0

  # Timestamp
  local ts
  ts=$(date --iso-8601=seconds 2>/dev/null || date "+%Y-%m-%dT%H:%M:%S")

  # Çalışılan dizin
  local cwd="$PWD"

  # Boş path ise yazma
  [[ -z "$MACHINE_SHELL_HISTORY_FILE" ]] && return 0

  print -r -- "$ts|$cwd|$exit_code|$cmd" >> "$MACHINE_SHELL_HISTORY_FILE"
}

# Bu fonksiyonu precmd zincirine ekle (Zsh'in hook sistemi)
typeset -ga precmd_functions
precmd_functions=(_ms_telemetry_precmd $precmd_functions)

# =========================
# İstatistik: Top komutlar
# =========================

ms_stats() {
  if [[ -z "$MACHINE_SHELL_HISTORY_FILE" || ! -f "$MACHINE_SHELL_HISTORY_FILE" ]]; then
    echo "History log yok: $MACHINE_SHELL_HISTORY_FILE"
    return 1
  fi

  echo "===== MACHINE SHELL STATS (Top 10 commands) ====="
  # 4. alan komut, onu alıp sayıyoruz
  awk -F'|' '{print $4}' "$MACHINE_SHELL_HISTORY_FILE" \
    | sort \
    | uniq -c \
    | sort -nr \
    | head 10
}

alias stats='ms_stats'

# =========================
# İstatistik: Günlük komut sayısı (heatmap)
# =========================

ms_heatmap() {
  if [[ -z "$MACHINE_SHELL_HISTORY_FILE" || ! -f "$MACHINE_SHELL_HISTORY_FILE" ]]; then
    echo "History log yok: $MACHINE_SHELL_HISTORY_FILE"
    return 1
  fi

  echo "===== MACHINE SHELL HEATMAP (Günlük komut sayısı) ====="
  awk -F'|' '{print $1}' "$MACHINE_SHELL_HISTORY_FILE" \
    | cut -d'T' -f1 \
    | sort \
    | uniq -c \
    | awk '{printf "%s | %d\n", $2, $1}'
}

alias theat='ms_heatmap'

# =========================
# History Log Viewer
# =========================

hlog() {
  if [[ -z "$MACHINE_SHELL_HISTORY_FILE" || ! -f "$MACHINE_SHELL_HISTORY_FILE" ]]; then
    echo "History log yok: $MACHINE_SHELL_HISTORY_FILE"
    return 1
  fi

  awk -F'|' '
  BEGIN {
    # Başlık
    printf "\033[1;36m%-10s %-8s %-4s %-30s %s\033[0m\n", "Tarih", "Saat", "Kod", "Klasör", "Komut"
    print "────────── ──────── ──── ────────────────────────────── ─────────────────────────────────────"
  }
  {
    # 1: timestamp, 2: cwd, 3: exit, 4: cmd
    split($1, dt, "T")
    date = dt[1]
    time = dt[2]
    gsub(/Z$/, "", time)  # sonda Z varsa sil

    cwd = $2
    if (length(cwd) > 28) {
      cwd = "…" substr(cwd, length(cwd)-27)
    }

    printf "%-10s %-8s %-4s %-30s %s\n", date, time, $3, cwd, $4
  }' "$MACHINE_SHELL_HISTORY_FILE" | less
}

hgrep() {
  if [[ -z "$1" ]]; then
    echo "Kullanım: hgrep <aranacak_kelime>"
    return 1
  fi

  if [[ -z "$MACHINE_SHELL_HISTORY_FILE" || ! -f "$MACHINE_SHELL_HISTORY_FILE" ]]; then
    echo "History log yok: $MACHINE_SHELL_HISTORY_FILE"
    return 1
  fi

  local pattern="$1"

  awk -F'|' -v pat="$pattern" '
  BEGIN {
    found = 0
    printf "\033[1;35m%-10s %-8s %-4s %-30s %s\033[0m\n", "Tarih", "Saat", "Kod", "Klasör", "Komut"
    print "────────── ──────── ──── ────────────────────────────── ─────────────────────────────────────"
  }
  {
    # 1: ts, 2: cwd, 3: exit, 4: cmd
    if ($0 ~ pat) {
      found = 1
      split($1, dt, "T")
      date = dt[1]
      time = dt[2]
      gsub(/Z$/, "", time)

      cwd = $2
      if (length(cwd) > 28) {
        cwd = "…" substr(cwd, length(cwd)-27)
      }

      printf "%-10s %-8s %-4s %-30s %s\n", date, time, $3, cwd, $4
    }
  }
  END {
    if (!found) {
      print "Eşleşme bulunamadı."
    }
  }' "$MACHINE_SHELL_HISTORY_FILE"
}
