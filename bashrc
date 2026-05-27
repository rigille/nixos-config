

# Commands that should be applied only for interactive shells.
[[ $- == *i* ]] || return

HISTFILESIZE=100000
HISTSIZE=10000

shopt -s histappend
shopt -s checkwinsize
shopt -s extglob
shopt -s globstar
shopt -s checkjobs



if [[ ! -v BASH_COMPLETION_VERSINFO ]]; then
  . "/nix/store/0zmgwbn1h48qrk6xn3qdbj2xm8vpk1n7-bash-completion-2.14.0/etc/profile.d/bash_completion.sh"
fi

eval "$(/nix/store/d5iair8lnb59rf2jj8f15hzp7nlhvkh8-zoxide-0.9.6/bin/zoxide init bash )"

#if test -n "$KITTY_INSTALLATION_DIR"; then
#  export KITTY_SHELL_INTEGRATION="no-rc"
#  source "$KITTY_INSTALLATION_DIR/shell-integration/bash/kitty.bash"
#fi

if [ "$TERM" = "tty33" ]; then
    PS1="$ "
    unset LS_COLORS
    alias ls='ls --color=never'
    alias grep='grep --color=never'
fi
