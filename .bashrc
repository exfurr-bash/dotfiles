# ==========================================
# GENTOO BASH RC — Tokyo Night Edition
# ==========================================

# ─── 1. Environment Variables & Settings ───────────────────────────
# export GALLIUM_DRIVER="zink" not everybody uses zink
export DISPLAY=":0"
export EDITOR="nano" # how to exit vim :((((
export PAGER="cat" # bat is annoying
export BAT_THEME="tokyonight_night"

# Adiciona ~/.opencode/bin ao PATH com segurança
if [ -d "$HOME/.opencode/bin" ] && [[ ":$PATH:" != *":$HOME/.opencode/bin:"* ]]; then
    export PATH="$HOME/.opencode/bin:$PATH"
fi

# ─── 2. History & Shell Options ────────────────────────────────────
shopt -s histappend
shopt -s lithist
shopt -s cmdhist
shopt -s promptvars
shopt -s autocd
shopt -s cdspell
shopt -s dirspell
shopt -s globstar
shopt -s no_empty_cmd_completion
shopt -s checkwinsize

HISTCONTROL=ignoreboth
HISTSIZE=10000
HISTFILESIZE=20000
HISTTIMEFORMAT="%F %T "
HISTIGNORE="ls:ll:l:cd:clear:c:exit:pwd:..:...:....:bg:fg:history:em:emsync"

# ─── 3. Completions ────────────────────────────────────────────────
# Caminhos padrão para bash-completion no Gentoo/Linux Padrão
if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

# ─── 4. Aliases ────────────────────────────────────────────────────
# Gentoo / Portage Aliases
alias em="sudo emerge -av"
alias emsync="sudo emerge --sync"
alias emupdate="sudo emerge -uDNav @world"
alias emdepclean="sudo emerge --depclean"

# Aliases de Usuário
alias lime='haxelib run lime'
# alias opencode='glibc-runner "$HOME/.opencode/bin/opencode"' # what if someone do not use termux

# Modern CLI Replacements
if command -v eza &>/dev/null; then
    alias ls='eza --icons=always --color=auto'
    alias ll='eza -lah --icons=always --color=auto --group-directories-first'
    alias l='eza -CF --icons=always --color=auto'
    alias la='eza -a --icons=always --color=auto'
    alias lt='eza -T --icons=always --color=auto'
    alias tree='eza -T --icons=always --color=auto'
else
    alias ls='ls --color=auto'
    alias ll='ls -lah --color=auto'
    alias l='ls -C --color=auto'
fi

# Modern Commands Check
command -v rg &>/dev/null && alias g='rg'
command -v bat &>/dev/null && alias b='bat --paging=never'
command -v dust &>/dev/null && alias du='dust'
command -v duf &>/dev/null && alias df='duf'
command -v htop &>/dev/null && alias top='htop'
command -v procs &>/dev/null && alias ps='procs'

# Utilitários Padrão
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias c='clear'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias vi='nvim'
alias vim='nvim'

# ─── 5. Functions ──────────────────────────────────────────────────
mkcd() { mkdir -p "$1" && cd "$1"; }

extrair() {
    if [ -f "$1" ]; then
        case "$1" in
            *.tar.bz2|*.tbz2) tar xvjf "$1"   ;;
            *.tar.gz|*.tgz)   tar xvzf "$1"   ;;
            *.tar)            tar xvf "$1"    ;;
            *.bz2)            bunzip2 "$1"    ;;
            *.rar)            unrar x "$1"    ;;
            *.gz)             gunzip "$1"     ;;
            *.zip)            unzip "$1"      ;;
            *.Z)              uncompress "$1" ;;
            *.7z)             7z x "$1"       ;;
            *)                echo "Não sei como extrair '$1'..." ;;
        esac
    else
        echo "'$1' não é um ficheiro válido!"
    fi
}

# ─── 6. Prompt Customization (Furry Style) ─────────────────────────
parse_git_branch() {
    if command -v git &>/dev/null && git rev-parse --is-inside-work-tree &>/dev/null 2>&1; then
        local branch dirty
        branch=$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)
        if [ -n "$(git status --porcelain 2>/dev/null)" ]; then
            dirty=" \[\e[38;5;203m\]✦"
        fi
        printf "─[\[\e[38;5;212m\]%s%s\[\e[38;5;141m\]]" "$branch" "$dirty"
    fi
}

parse_bg_jobs() {
    local jobs_num=$(jobs -p | wc -l)
    if [ "$jobs_num" -gt 0 ]; then
        printf "─[\[\e[38;5;220m\]&%d\[\e[38;5;141m\]]" "$jobs_num"
    fi
}

# Paleta Pastel
C_BORDER='\[\e[38;5;141m\]'
C_TIME='\[\e[38;5;223m\]'
C_USER='\[\e[38;5;117m\]'
C_DIR='\[\e[38;5;120m\]'
C_RESET='\[\e[0m\]'

set_prompt() {
    local exit_code=$?
    local furry_face arrow_color
    
    if [ $exit_code -eq 0 ]; then
        furry_face="\[\e[38;5;212m\]( ^w^ )"
        arrow_color='\[\e[38;5;117m\]'
    else
        furry_face="\[\e[38;5;203m\]( xwx )"
        arrow_color='\[\e[38;5;203m\]'
    fi

    local git_info=$(parse_git_branch)
    local jobs_info=$(parse_bg_jobs)
    
    PS1="${C_BORDER}┌─[${C_TIME}\t${C_BORDER}]─[${C_USER}\u@\h${C_BORDER}]─[${C_DIR}\w${C_BORDER}]${git_info}${jobs_info}\n└─${furry_face} ${arrow_color}❯${C_RESET} "
}

PROMPT_COMMAND=set_prompt

# ─── 7. Integrations & Greeting ────────────────────────────────────
if command -v fzf &>/dev/null; then
    eval "$(fzf --bash 2>/dev/null)"
    export FZF_DEFAULT_OPTS="--color=bg+:#1f2335,bg:#1a1b26,spinner:#7dcfff,hl:#7aa2f7,fg:#c0caf5,header:#7dcfff,info:#e0af68,pointer:#7aa2f7,marker:#f7768e,fg+:#c0caf5,prompt:#7dcfff,hl+:#7aa2f7"
fi

command -v zoxide &>/dev/null && eval "$(zoxide init bash)"
command -v fastfetch &>/dev/null && fastfetch
