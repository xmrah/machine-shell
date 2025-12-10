# nav.zsh – Machine Shell Navigation v1.2
# Bookmark tabanlı dizin warp sistemi

# Sadece interaktif shell'de çalışsın
[[ -o interactive ]] || return 0

# Bookmark dosyası yolu
: ${MACHINE_SHELL_MARKS_FILE:="$HOME/.local/share/machine-shell/marks"}
mkdir -p "${MACHINE_SHELL_MARKS_FILE:h}"
touch "$MACHINE_SHELL_MARKS_FILE"

# Format: name|path

# Mevcut bookmark'ları göster
marks() {
  if [[ ! -s "$MACHINE_SHELL_MARKS_FILE" ]]; then
    echo "Hiç bookmark yok. Bulunduğun dizini kaydetmek için: mark <isim>"
    return 0
  fi

  echo "📍 Machine Shell Marks:"

  # Aynı isim birden fazla varsa, SON kaydı göster
  awk -F'|' '
    {
      map[$1] = $2
    }
    END {
      for (k in map) {
        printf "  %-12s → %s\n", k, map[k]
      }
    }
  ' "$MACHINE_SHELL_MARKS_FILE"
}

# Yeni bookmark ekle
mark() {
  local name="$1"
  if [[ -z "$name" ]]; then
    echo "Kullanım: mark <isim>"
    return 1
  fi

  local path="$PWD"

  # Aynı isimden birden fazla olabilir, SON satır geçerli kabul edilecek
  print -r -- "$name|$path" >> "$MACHINE_SHELL_MARKS_FILE"

  echo "✅ '$name' → $path olarak kaydedildi."
}

# Eğer c diye alias varsa, fonksiyondan önce temizle
if alias c >/dev/null 2>&1; then
  unalias c
fi

# c → bookmark warp komutu
c() {
  # c <isim>  → o bookmark'a cd
  # c        → fzf ile seçim
  if [[ ! -s "$MACHINE_SHELL_MARKS_FILE" ]]; then
    echo "Bookmark yok. Önce mark <isim> kullan."
    return 1
  fi

  local name="$1"

  if [[ -z "$name" ]]; then
    # fzf ile seçim
    if ! command -v fzf >/dev/null 2>&1; then
      echo "fzf yok, c <isim> şeklinde kullan."
      return 1
    fi

    local selected
    selected=$(
      awk -F'|' '{printf "%-12s %s\n", $1, $2}' "$MACHINE_SHELL_MARKS_FILE" \
      | fzf --prompt="cd> " --header="Bookmark seç (enter ile git)" --reverse
    ) || return 1

    name=${selected%% *}
  fi

  local target
  # Aynı isimden birden fazla varsa SON kaydı kullan
  target=$(awk -F'|' -v n="$name" '$1 == n {last=$2} END {if (last) print last}' "$MACHINE_SHELL_MARKS_FILE")

  if [[ -z "$target" ]]; then
    echo "'$name' diye bir bookmark yok."
    return 1
  fi

  cd "$target" || {
    echo "Dizine gidilemedi: $target"
    return 1
  }
}

# Küçük hazır kısayollar (ister kullan, ister sil)
alias mhome='mark home'
alias mshell='mark shell'
alias mtmp='mark tmp'
