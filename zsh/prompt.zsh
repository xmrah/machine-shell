# Machine Shell – Minimal Prompt (Final Stable Version)

autoload -Uz colors && colors
setopt prompt_subst

# Sol prompt (renkli)
machine_header() {
  print -n "%{$fg[magenta]%}%n%{$reset_color%}@%{$fg[cyan]%}%m%{$reset_color%} %{$fg[yellow]%}%~%{$reset_color%}"
}

# PROMPT → iki satır
PROMPT=$'\n$(machine_header)\n# '

# Sağ prompt tamamen kapalı
RPS1=""
