# Machine Shell – Prompt v1
# P10k yok, gizli sihir yok. Tamamen okunabilir, senin kontrolünde.

autoload -Uz colors && colors

# Sol tarafta gözüken prompt’u hesaplayan fonksiyon
machine_left_prompt() {
  # %n = kullanıcı adı, %m = host (makine adı), %~ = kısaltılmış klasör yolu
  print -n "%{$fg[magenta]%}%n%{$reset_color%}@%{$fg[cyan]%}%m%{$reset_color%} %{$fg[yellow]%}%~%{$reset_color%}"
}

# İki satırlı prompt:
# user@host ~
# $
PROMPT=$'\n$(machine_left_prompt)\n$ '

# Sağ taraf (ileride HUD, saat, git info vs. için burayı kullanabiliriz)
RPS1=""
