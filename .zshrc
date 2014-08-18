# The following lines were added by compinstall

zstyle ':completion:*' completer _expand _complete _ignored _correct _approximate
zstyle :compinstall filename '/home/yousef/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=20000
setopt appendhistory autocd
unsetopt beep
bindkey -e
# End of lines configured by zsh-newuser-install
autoload -U promptinit
autoload -U colors && colors
promptinit
PROMPT="%{$fg[yellow]%}[%n@%m%{$reset_color%} %{$fg[green]%}%~%{$reset_color%}%{$fg[yellow]%}]$%{$reset_color%} "
RPROMPT="[%{$fg[yellow]%}%?%{$reset_color%}]"
