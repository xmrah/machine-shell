# dashboard.zsh – Machine Shell açılış ekranı

# Sadece interaktif shell'de çalış
[[ -o interactive ]] || return 0

# Davranış kontrolü:
# MACHINE_SHELL_DASHBOARD = fast | neo | off
: ${MACHINE_SHELL_DASHBOARD:=fast}

_ms_show_dashboard() {
  case "$MACHINE_SHELL_DASHBOARD" in
    off)
      return 0
      ;;
    fast)
      if command -v fastfetch >/dev/null 2>&1; then
        fastfetch
        return 0
      fi
      ;;
    neo)
      if command -v neofetch >/dev/null 2>&1; then
        neofetch
        return 0
      fi
      ;;
  esac

  # Otomatik fallback:
  if command -v fastfetch >/dev/null 2>&1; then
    fastfetch
  elif command -v neofetch >/dev/null 2>&1; then
    neofetch
  fi
}

_ms_show_dashboard
