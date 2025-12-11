# reflex.zsh – Machine Shell Reflex Engine v3 (mode-aware + first-run fix)

autoload -Uz add-zsh-hook

# History dosyası ve state
: ${MS_HISTORY_FILE:="$HOME/.local/share/machine-shell/history.log"}
typeset -g MS_REFLEX_LAST_TS=""
typeset -gi MS_REFLEX_INIT_DONE=0

_ms_reflex_enabled() {
  [[ "$MS_REFLEX" != "off" ]]
}

_ms_reflex_check_log() {
  [[ -f "$MS_HISTORY_FILE" ]]
}

_ms_reflex_precmd() {
  _ms_reflex_enabled || return 0
  _ms_reflex_check_log || return 0

  local level="${MS_REFLEX_LEVEL:-2}"
  (( level <= 0 )) && return 0

  # Son satırı al
  local line ts rest cwd exit_code cmd
  line=$(tail -n 1 -- "$MS_HISTORY_FILE" 2>/dev/null) || return 0
  [[ -z "$line" ]] && return 0

  ts=${line%%|*}
  rest=${line#*|}
  cwd=${rest%%|*}
  rest=${rest#*|}
  exit_code=${rest%%|*}
  cmd=${rest#*|}

  [[ -z "$cmd" ]] && return 0

  # İlk precmd çağrısında SADECE ts'i kaydet, hiçbir şey yazma
  if (( MS_REFLEX_INIT_DONE == 0 )); then
    MS_REFLEX_LAST_TS="$ts"
    MS_REFLEX_INIT_DONE=1
    return 0
  fi

  # Aynı satırı iki kere işlemeyelim
  [[ "$ts" == "$MS_REFLEX_LAST_TS" ]] && return 0
  MS_REFLEX_LAST_TS="$ts"

  # Çok trivial komutları atla
  case "$cmd" in
    cd*|ls|pwd|clear|history|ms-*|alias*|echo* )
      return 0
    ;;
  esac

  # LEVEL 1 → sadece çok kritik olaylarda konuş (NUCLEAR modu)
  if (( level == 1 )); then
    if [[ "$cmd" == *"rm -rf"* ]]; then
      echo -e "\n🧨 Reflex: Yüksek riskli silme komutu çalıştı."
      return 0
    fi
    if [[ "$cmd" == sudo* ]]; then
      echo -e "\n🔐 Reflex: sudo kullanıldı."
      return 0
    fi
    if [[ "$cmd" == *"pacman -Syu"* ]]; then
      echo -e "\n⬆️  Reflex: Sistem güncellemesi çalıştı (pacman -Syu)."
      return 0
    fi
    return 0
  fi

  # LEVEL >= 2 → hata + risk + git + sudo vs.

  if [[ "$exit_code" != "0" ]]; then
    echo -e "\n⚠️  Reflex: Komut hata ile bitti (exit=$exit_code)"
    echo "   → $cmd"
    return 0
  fi

  if [[ "$cmd" == *"rm -rf"* ]]; then
    echo -e "\n🧨 Reflex: Yüksek riskli silme komutu çalıştı:"
    echo "   → $cmd"
    return 0
  fi

  if [[ "$cmd" == "sudo pacman -Syu"* || "$cmd" == *"pacman -Syu"* ]]; then
    echo -e "\n⬆️  Reflex: Sistem güncellemesi tespit edildi (pacman -Syu)."
    return 0
  fi

  if [[ "$cmd" == sudo* ]]; then
    echo -e "\n🔐 Reflex: sudo kullanıldı."
    return 0
  fi

  if [[ "$cmd" == git\ * ]]; then
    echo -e "\n🌱 Reflex: Git komutu çalıştı:"
    echo "   → $cmd"
    return 0
  fi

  return 0
}

add-zsh-hook precmd _ms_reflex_precmd
