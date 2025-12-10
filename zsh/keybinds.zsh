# keybinds.zsh – Machine Shell Keybindings v1

# Widget: stats
function _ms_stats() {
  stats
  zle reset-prompt
}
zle -N _ms_stats

# Widget: heatmap
function _ms_heatmap() {
  theat
  zle reset-prompt
}
zle -N _ms_heatmap

# Widget: git status
function _ms_git() {
  git status
  zle reset-prompt
}
zle -N _ms_git

# Keybindings
# Alt + s → stats
bindkey "^[s" _ms_stats

# Alt + h → heatmap
bindkey "^[h" _ms_heatmap

# Ctrl + g → git status
bindkey "^[G" _ms_git
