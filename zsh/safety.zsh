# Machine Shell – Safety v1
# Görev: rm komutunu korumalı hale getirmek.

# Log klasörü (telemetry ile aynı path'i kullanıyoruz)
: "${MACHINE_SHELL_LOG_DIR:=${XDG_DATA_HOME:-$HOME/.local/share}/machine-shell}"
MACHINE_SHELL_SAFETY_LOG="$MACHINE_SHELL_LOG_DIR/safety.log"

mkdir -p "$MACHINE_SHELL_LOG_DIR"

# Risk skorlayıcı: argümanlara bakıp 0–100 arası risk döndürür
ms_risk_rm() {
  local args="$*"
  local score=0

  # -rf varsa risk yüksek
  if [[ "$args" == *"-rf"* ]]; then
    (( score += 60 ))
  fi

  # root veya en üst seviye klasörler
  if [[ "$args" == "/" || "$args" == "/*" || "$args" == "/home" || "$args" == "/home/"* ]]; then
    (( score += 50 ))
  fi

  # * kullanımı (geniş silme)
  if [[ "$args" == *" *"* ]]; then
    (( score += 20 ))
  fi

  echo $score
}

# Orijinal /bin/rm yolu
MS_RM_BIN="$(command -v rm)"

# rm override
rm() {
  # Hiç argüman yoksa eski davranış
  if [[ "$#" -eq 0 ]]; then
    "$MS_RM_BIN"
    return $?
  fi

  local args=("$@")
  local joined="$*"
  local risk
  risk=$(ms_risk_rm "$joined")

  # Düşük risk -> direkt çalıştır
  if (( risk < 60 )); then
    "$MS_RM_BIN" "${args[@]}"
    return $?
  fi

  # Yüksek risk ise uyar
  echo "⚠️  MACHINE-SHELL SAFETY: Yüksek riskli rm tespit edildi."
  echo "    Komut: rm $joined"
  echo "    Risk skoru: $risk / 100"
  echo -n "    Gerçekten çalıştırmak istiyor musun? [y/N]: "

  local answer
  read answer

  if [[ "$answer" != "y" && "$answer" != "Y" ]]; then
    echo "❌ İşlem iptal edildi."
    # Logla
    printf '%s|BLOCKED|rm %s\n' "$(date +"%Y-%m-%dT%H:%M:%S")" "$joined" >> "$MACHINE_SHELL_SAFETY_LOG"
    return 1
  fi

  # Onay verdin -> logla ve çalıştır
  printf '%s|ALLOWED|rm %s\n' "$(date +"%Y-%m-%dT%H:%M:%S")" "$joined" >> "$MACHINE_SHELL_SAFETY_LOG"
  "$MS_RM_BIN" "${args[@]}"
}
