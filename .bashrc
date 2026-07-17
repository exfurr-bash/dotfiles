# ==========================================
# 1. ENVIRONMENT VARIABLES & SETTINGS
# ==========================================
export GALLIUM_DRIVER=zink
export DISPLAY=:0

# Só adiciona ao PATH se o diretório realmente existir (Evita caminhos fantasma)
if [ -d "$HOME/.opencode/bin" ]; then
    if [[ ":$PATH:" != *":$HOME/.opencode/bin:"* ]]; then
        export PATH="$HOME/.opencode/bin:$PATH"
    fi
fi

# Configurações Avançadas do Histórico
shopt -s histappend
shopt -s lithist
shopt -s cmdhist
HISTCONTROL=ignoreboth
HISTSIZE=10000
HISTFILESIZE=20000
HISTTIMEFORMAT="%F %T "
HISTIGNORE="ls:ll:l:cd:clear:c:exit:pwd:..:...:....:bg:fg:history"
shopt -s promptvars

# Shell options
shopt -s autocd
shopt -s cdspell
shopt -s dirspell
shopt -s globstar
shopt -s no_empty_cmd_completion
shopt -s checkwinsize

# ==========================================
# 1.5. COMPLETIONS & INTEGRATIONS
# ==========================================

# bash-completion
if [ -f /data/data/com.termux/files/usr/share/bash-completion/bash_completion ]; then
    . /data/data/com.termux/files/usr/share/bash-completion/bash_completion
fi

# fzf key bindings
if command -v fzf &>/dev/null; then
    eval "$(fzf --bash 2>/dev/null)"
fi

# zoxide (smart cd)
if command -v zoxide &>/dev/null; then
    eval "$(zoxide init bash)"
fi

# ==========================================
# 2. ALIASES & FUNCTIONS
# ==========================================
# Aliases Originais do Usuário
alias lime='haxelib run lime'
alias opencode='glibc-runner /data/data/com.termux/files/home/.opencode/bin/opencode'

# Melhorias de Listagem e Cores Nativas
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias ll='ls -lah --color=auto'
alias l='ls -C --color=auto'

# Navegação Rápida de Pastas
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias c='clear'

# Aliases de Segurança (Prevenção de acidentes)
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# Função útil: Cria um diretório e entra nele instantaneamente
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Função útil: Extrator universal de ficheiros compactados
extrair() {
    if [ -f "$1" ] ; then
        case "$1" in
            *.tar.bz2)   tar xvjf "$1"    ;;
            *.tar.gz)    tar xvzf "$1"    ;;
            *.bz2)       bunzip2 "$1"     ;;
            *.rar)       unrar x "$1"     ;;
            *.gz)        gunzip "$1"      ;;
            *.tar)       tar xvf "$1"     ;;
            *.tbz2)      tar xvjf "$1"    ;;
            *.tgz)       tar xvzf "$1"    ;;
            *.zip)       unzip "$1"       ;;
            *.Z)         uncompress "$1"  ;;
            *.7z)        7z x "$1"        ;;
            *)           echo "Não sei como extrair '$1'..." ;;
        esac
    else
        echo "'$1' não é um ficheiro válido!"
    fi
}

# ==========================================
# 3. PROMPT CUSTOMIZATION (PS1) - FURRY STYLE
# ==========================================

# Utilitário do Git com Failsafe (Não quebra se o git não estiver instalado)
parse_git_branch() {
    if command -v git &>/dev/null; then
        if git rev-parse --is-inside-work-tree &>/dev/null; then
            local branch dirty
            branch=$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)
            if [ -n "$(git status --porcelain 2>/dev/null)" ]; then
                dirty=" \[\e[38;5;203m\]✦" # Brilho em tom vermelho/coral
            fi
            printf "─[\[\e[38;5;212m\]%s%s\[\e[38;5;141m\]]" "$branch" "$dirty"
        fi
    fi
}

# Utilitário de Background Jobs: Mostra se há processos parados ou em segundo plano
parse_bg_jobs() {
    local jobs_num
    jobs_num=$(jobs -p | wc -l)
    if [ "$jobs_num" -gt 0 ]; then
        printf "─[\[\e[38;5;220m\]&%d\[\e[38;5;141m\]]" "$jobs_num"
    fi
}

# Paleta de Cores Pastel (256-color)
C_BORDER='\[\e[38;5;141m\]'  # Roxo Pastel
C_TIME='\[\e[38;5;223m\]'    # Creme/Pêssego
C_USER='\[\e[38;5;117m\]'    # Azul Céu Suave
C_DIR='\[\e[38;5;120m\]'     # Verde Menta
C_RESET='\[\e[0m\]'

# Função que monta o prompt dinamicamente a cada comando
set_prompt() {
    local exit_code=$?  # Captura o status do comando anterior imediatamente
    
    local furry_face
    local arrow_color
    
    if [ $exit_code -eq 0 ]; then
        furry_face="\[\e[38;5;212m\]( ^w^ )"   # Carinha feliz (Rosa Pastel)
        arrow_color='\[\e[38;5;117m\]'         # Seta Azul
    else
        furry_face="\[\e[38;5;203m\]( xwx )"   # Carinha de erro (Vermelho Pastel)
        arrow_color='\[\e[38;5;203m\]'         # Seta Vermelha
    fi

    local git_info=$(parse_git_branch)
    local jobs_info=$(parse_bg_jobs)
    
    # Estrutura final do prompt multi-linha
    PS1="${C_BORDER}┌─[${C_TIME}\t${C_BORDER}]─[${C_USER}\u@\h${C_BORDER}]─[${C_DIR}\w${C_BORDER}]${git_info}${jobs_info}\n└─${furry_face} ${arrow_color}❯${C_RESET} "
}

# Define a execução da função antes de renderizar o prompt
PROMPT_COMMAND=set_prompt

# ==========================================
# 4. GREETING (SAFE)
# ==========================================
# Executa o sumário visual apenas se uma das ferramentas estiver de fato instalada
if command -v fastfetch &>/dev/null; then
    fastfetch
elif command -v neofetch &>/dev/null; then
    neofetch
fi

