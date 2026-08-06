# ──────────────────────────────────────────────
# GENTOO ZSH RC — Tokyo Night Edition
# ──────────────────────────────────────────────

# ─── Environment ───────────────────────────────────────────────────
export EDITOR="nvim" # Alterado de nano para nvim para combinar com seus aliases
export PAGER="less -R" # Pager padrão mais robusto que o cat
export BAT_THEME="tokyonight_night"
export SHELL="/usr/bin/zsh"

# OpenCode Path
export PATH="/home/iris/.opencode/bin:$PATH"

# ─── History ───────────────────────────────────────────────────────
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=20000
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY
setopt APPEND_HISTORY

# ─── Completion ────────────────────────────────────────────────────
autoload -Uz compinit && compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' verbose yes
zstyle ':completion:*' group-name ''
zstyle ':completion:*' format '[%d]'

# ─── Zsh Plugins (Gentoo / Local Fallback) ─────────────────────────
# Tenta carregar os plugins do Portage primeiro, depois cai para o seu diretório local
local plugin_paths=(
  "/usr/share/zsh/site-functions"
  "/usr/share/zsh/site-contrib"
  "$HOME/.zsh"
)

for p_path in $plugin_paths; do
  [[ -f "$p_path/zsh-autosuggestions/zsh-autosuggestions.zsh" ]] && source "$p_path/zsh-autosuggestions/zsh-autosuggestions.zsh"
  [[ -f "$p_path/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]] && source "$p_path/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
  [[ -f "$p_path/zsh-completions/zsh-completions.plugin.zsh" ]] && source "$p_path/zsh-completions/zsh-completions.plugin.zsh"
done

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#565f89"

# ─── Terminal Title & Furry Prompt ─────────────────────────────────
set_title() { print -Pn "\e]2;%n@%m: %~\a" }

parse_git_branch() {
  if command -v git &>/dev/null && git rev-parse --is-inside-work-tree &>/dev/null 2>&1; then
    local branch dirty
    branch=$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)
    [[ -n $(git status --porcelain 2>/dev/null) ]] && dirty="%F{203}✦"
    print -n "─[%F{212}${branch}${dirty}%F{141}]"
  fi
}

parse_bg_jobs() {
  local jobs_num=$(jobs | wc -l)
  (( jobs_num > 0 )) && print -n "─[%F{220}&${jobs_num}%F{141}]"
}

build_prompt() {
  local git_info=$(parse_git_branch)
  local jobs_info=$(parse_bg_jobs)
  PROMPT="%F{141}┌─[%F{223}%*%F{141}]─[%F{117}%n@%m%F{141}]─[%F{120}%~%F{141}]${git_info}${jobs_info}
└─%(?.%F{212}( ^w^ ).%F{203}( xwx )) %(?.%F{117}.%F{203})❯%f "
}

autoload -Uz add-zsh-hook
add-zsh-hook precmd set_title
add-zsh-hook precmd build_prompt

# ─── LS Colors (Tokyo Night) ──────────────────────────────────────
export LS_COLORS="di=1;38;2;125;207;255:ex=1;38;2;247;118;142:fi=38;2;192;202;245:ln=38;2;187;154;247:or=38;2;247;118;142:bd=38;2;224;175;104:cd=38;2;224;175;104:pi=38;2;158;206;106:so=38;2;125;207;255:sg=38;2;158;206;106:su=38;2;158;206;106:tw=38;2;125;207;255:ow=38;2;125;207;255:st=38;2;187;154;247:*.c=38;2;122;162;247:*.cpp=38;2;122;162;247:*.h=38;2;122;162;247:*.rs=38;2;224;175;104:*.py=38;2;158;206;106:*.js=38;2;224;175;104:*.ts=38;2;122;162;247:*.lua=38;2;125;207;255:*.md=38;2;192;202;245:*.txt=38;2;192;202;245:*.toml=38;2;158;206;106:*.json=38;2;224;175;104:*.yml=38;2;125;207;255:*.yaml=38;2;125;207;255:*.png=38;2;187;154;247:*.jpg=38;2;187;154;247:*.jpeg=38;2;187;154;247:*.svg=38;2;187;154;247:*.mp3=38;2;247;118;142:*.mp4=38;2;247;118;142:*.zip=38;2;224;175;104:*.tar=38;2;224;175;104:*.gz=38;2;224;175;104:*.7z=38;2;224;175;104:*.pdf=38;2;247;118;142"

# ─── Aliases ───────────────────────────────────────────────────────
# Gentoo / Portage Aliases
alias em="sudo emerge -av"       # Instalar pacotes interativamente
alias emsync="sudo emerge --sync" # Sincronizar a árvore do Portage
alias emupdate="sudo emerge -uDNav @world" # Atualizar o sistema
alias emdepclean="sudo emerge --depclean" # Limpar dependências órfãs

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

# Utility Aliases
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

# Modern Commands Check
command -v rg &>/dev/null && alias g='rg'
command -v bat &>/dev/null && alias b='bat --paging=never'
command -v dust &>/dev/null && alias du='dust'
command -v duf &>/dev/null && alias df='duf'
command -v htop &>/dev/null && alias top='htop'
command -v procs &>/dev/null && alias ps='procs'

# ─── Functions ─────────────────────────────────────────────────────
mkcd() { mkdir -p "$1" && cd "$1" }

extrair() {
  if [[ -f "$1" ]]; then
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

# ─── Integrations ──────────────────────────────────────────────────
if command -v fzf &>/dev/null; then
  source <(fzf --zsh)
  export FZF_DEFAULT_OPTS="--color=bg+:#1f2335,bg:#1a1b26,spinner:#7dcfff,hl:#7aa2f7,fg:#c0caf5,header:#7dcfff,info:#e0af68,pointer:#7aa2f7,marker:#f7768e,fg+:#c0caf5,prompt:#7dcfff,hl+:#7aa2f7"
fi

command -v zoxide &>/dev/null && eval "$(zoxide init zsh)"

# ─── Greeting ──────────────────────────────────────────────────────
command -v fastfetch &>/dev/null && fastfetch
# ─── Keybindings (Ctrl + Setas) ──────────────────────────────────
bindkey -e                           # Garante modo Emacs (padrão)
bindkey "^[[1;5C" forward-word       # Ctrl + Seta Direita
bindkey "^[[1;5D" backward-word      # Ctrl + Seta Esquerda
bindkey "^[[5C"   forward-word       # Variação de Ctrl + Seta Direita
bindkey "^[[5D"   backward-word      # Variação de Ctrl + Seta Esquerda
bindkey "^[Oc"    forward-word       # Variação para alguns emuladores
bindkey "^[Od"    backward-word      # Variação para alguns emuladores
