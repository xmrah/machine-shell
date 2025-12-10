# Machine Shell – Core v1
# Burada sadece "çekirdek" Zsh ayarları var. Tema, alias, AI vb. yok.

##### HISTORY #####

HISTFILE="$HOME/.zsh_history"
HISTSIZE=5000
SAVEHIST=20000

setopt hist_ignore_dups         # aynı komutu üst üste kaydetme
setopt hist_ignore_space        # başı boşluklu komutları kaydetme
setopt share_history            # tüm zsh oturumları history paylaşsın
setopt inc_append_history       # komut çalışınca anında history dosyasına yaz

##### KULLANIM RAHATLIĞI #####

setopt auto_cd                  # sadece klasör adını yazarak cd
setopt interactive_comments     # satırda # sonrası yorum kabul et
setopt correct                  # ufak typo'larda "şunu mu demek istedin" uyarısı
setopt prompt_subst             # PROMPT içinde $(...) çalışabilsin

##### GLOBBING / PATTERN #####

setopt extended_glob            # gelişmiş glob desenlerini aç

##### PATH #####

path=(
  $HOME/.local/bin
  $path
)

export PATH

##### EDITOR #####

export EDITOR="nano"

# =========================
# History ayarları
# =========================
HISTFILE="$HOME/.zsh_history"
HISTSIZE=5000
SAVEHIST=5000

setopt SHARE_HISTORY         # Tüm zsh oturumları aynı history'yi paylaşsın
setopt HIST_IGNORE_DUPS      # Aynı komutu üst üste yazınca tekrar kaydetmesin
setopt HIST_IGNORE_SPACE     # Başına boşluk bıraktığın komutları history'ye yazmasın
setopt EXTENDED_HISTORY      # Timestamp'li history

# =========================
# Tamamlama sistemi (compinit)
# =========================
autoload -Uz compinit

# Dump dosyası yoksa normal başlat, varsa hızlı mod
if [[ ! -f "$HOME/.zcompdump" ]]; then
  compinit
else
  compinit -C
fi

# Tamamlama stilini biraz insancıl yapalım
zstyle ':completion:*' menu select
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '%F{yellow}%d%f'
zstyle ':completion:*' completer _complete _ignored

# =========================
# History-beginning search (fish vari)
# =========================
# Yaz: "pac", sonra ↑ ile sadece "pac..." ile başlayan history içinde gez
bindkey '^[[A' history-beginning-search-backward
bindkey '^[[B' history-beginning-search-forward


