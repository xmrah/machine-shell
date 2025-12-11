# mode.zsh – Machine Shell Mode System v1
# Mod profilleri: SAFE, DEV, NUCLEAR

# Aktif modu global değişkende tutuyoruz
export MACHINE_MODE="SAFE"

# Modun parametrelerini ayarla
function _ms_apply_mode() {
  case "$MACHINE_MODE" in
    SAFE)
      export MS_SAFETY_LEVEL=3     # En yüksek koruma
      export MS_REFLEX_LEVEL=2     # Reflex açık, detaylı uyarı
      export MS_LOG_LEVEL=2        # Tam loglama
      ;;
    DEV)
      export MS_SAFETY_LEVEL=2     # Orta seviye koruma
      export MS_REFLEX_LEVEL=3     # Hacker tarzı hızlı reflex
      export MS_LOG_LEVEL=1        # Özet log
      ;;
    NUCLEAR)
      export MS_SAFETY_LEVEL=0     # Koruma kapalı (çok tehlikeli!)
      export MS_REFLEX_LEVEL=1     # Minimum reflex
      export MS_LOG_LEVEL=0        # Log yok
      ;;
  esac
}

# Mode değiştirme komutu
function ms-mode() {
  local new="$1"

  case "$new" in
    safe|SAFE)
      MACHINE_MODE="SAFE"
      ;;
    dev|DEV)
      MACHINE_MODE="DEV"
      ;;
    nuclear|NUCLEAR)
      MACHINE_MODE="NUCLEAR"
      ;;
    *)
      echo "Kullanım: ms-mode {safe|dev|nuclear}"
      return 1
      ;;
  esac

  _ms_apply_mode
  echo "🔧 Mode: $MACHINE_MODE (Safety=$MS_SAFETY_LEVEL, Reflex=$MS_REFLEX_LEVEL)"
}

# Zsh açıldığında varsayılan modu uygula
_ms_apply_mode
