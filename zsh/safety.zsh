# safety.zsh – Machine Shell Safety v2 (mode-aware)

MS_HISTORY_FILE="${MS_HISTORY_FILE:-$HOME/.local/share/machine-shell/history.log}"
MS_SAFETY_LOG="${MS_SAFETY_LOG:-$HOME/.local/share/machine-shell/safety.log}"

mkdir -p "$(dirname "$MS_SAFETY_LOG")"

_ms_log_safety() {
  local ts action cmd
  ts=$(date --iso-8601=seconds)
  action="$1"
  cmd="$2"
  echo "${ts}|${action}|${cmd}" >> "$MS_SAFETY_LOG"
}

_ms_is_dangerous_rm() {
  # rm -rf varsa tehlikeli
  [[ "$*" == *"-rf"* || "$*" == *"-fr"* ]]
}

# rm override – mode-aware
function rm() {
  local level="${MS_SAFETY_LEVEL:-2}"
  local cmd="rm $*"

  # NUCLEAR → hiç karışma
  if (( level <= 0 )); then
    command rm "$@"
    return $?
  fi

  if _ms_is_dangerous_rm "$@"; then
    # SAFE vs DEV davranışı
    local target="$*"

    # DEV mode: /tmp içindeyse sorunsuz çalıştır
    if (( level == 2 )) && [[ "$target" == *"/tmp"* ]]; then
      _ms_log_safety "ALLOWED_DEV_TMP" "$cmd"
      command rm "$@"
      return $?
    fi

    echo "⚠  MACHINE-SHELL SAFETY: Yüksek riskli rm tespit edildi."
    echo "    Komut: $cmd"
    echo "    Risk skoru: 60 / 100"

    local ans
    read -r "ans?    Gerçekten çalıştırmak istiyor musun? [y/N]: "

    if [[ "$ans" != "y" && "$ans" != "Y" ]]; then
      echo "    İptal edildi."
      _ms_log_safety "BLOCKED" "$cmd"
      return 1
    fi

    _ms_log_safety "ALLOWED" "$cmd"
    command rm "$@"
    return $?
  fi

  # Normal rm
  command rm "$@"
}
