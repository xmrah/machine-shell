# Machine Shell – AI Hooks v1
# Burada local LLM / LM Studio / Ollama gibi sistemlere köprü kurulacak.
# Şimdilik tamamen isteğe bağlı, boşa çalışsa bile sistem bozmaz.

# AI özelliğini aç/kapa bayrağı (ileride config'e bağlayabiliriz)
: "${MACHINE_AI_ENABLED:=false}"

# Basit bir helper: terminalden AI'ye soru sormak için
askai() {
  if [[ "$MACHINE_AI_ENABLED" != "true" ]]; then
    echo "🧠 AI devre dışı (MACHINE_AI_ENABLED=true yapmadıkça çalışmaz)."
    return 1
  fi

  if ! command -v curl >/dev/null 2>&1; then
    echo "curl bulunamadı. AI isteği atılamıyor."
    return 1
  fi

  # Burayı ileride LM Studio / Ollama API'ne göre dolduracağız.
  echo "🔮 Buraya AI entegrasyonu gelecek. Şu an sadece iskelet."
  return 0
}

# Hata analiz kısayolu – şimdilik sadece taslak
wtf() {
  echo "🤔 wtf: Son komut hatasını AI'ye soracak yapı için placeholder."
}
