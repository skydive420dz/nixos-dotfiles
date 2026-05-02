autoload -U colors && colors
setopt PROMPT_SUBST

ARROW=$'\ue0b0'

_seg_nix() {
    # Green block → green arrow into surface0
    echo -n $'\e[48;2;166;227;161m\e[38;2;30;30;46m NIX \e[0m\e[38;2;166;227;161m\e[48;2;49;50;68m'"$ARROW"$'\e[0m'
}

_seg_dir() {
    local dir="${$(print -P %3~)}"
    # Surface0 block → surface0 arrow into base (terminal bg)
    echo -n $'\e[48;2;49;50;68m\e[38;2;205;214;244m '"$dir"$' \e[0m\e[38;2;49;50;68m\e[48;2;24;24;37m'"$ARROW"$'\e[0m'
}

_seg_git() {
    local branch dirty
    branch=$(git branch --show-current 2>/dev/null)
    [[ -z $branch ]] && return
    [[ -n $(git status --short 2>/dev/null) ]] && dirty=" !"
    # Mantle bg, overlay text → mantle arrow fading darker
    echo -n $'\e[48;2;24;24;37m\e[38;2;88;91;112m '"$branch$dirty"$' \e[38;2;24;24;37m\e[49m'"$ARROW"$'\e[0m'
}

_seg_nix_shell() {
    [[ -z $IN_NIX_SHELL ]] && return
    echo -n $' \e[38;2;148;226;213m❄️  \e[38;2;24;24;37m'"$ARROW"$'\e[0m'
}

PROMPT='$(_seg_nix)$(_seg_dir)$(_seg_git)$(_seg_nix_shell)
'$'\e[38;2;166;227;161m''❯'$'\e[0m'' '

RPROMPT=''
