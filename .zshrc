#
# .zshrc
#
# @author Murat Gungor
# @credit Based on the original dotfiles by Jeff Geerling
#

# Colors.
unset LSCOLORS
export CLICOLOR=1
export CLICOLOR_FORCE=1

# Don't require escaping globbing characters in zsh.
unsetopt nomatch

# Configure vcs_info.
autoload -Uz vcs_info
zstyle ':vcs_info:git:*' formats ' %F{red}⎇ %b%f'
zstyle ':vcs_info:*' enable git

# Color variables (global scope).
COLOR_CYAN=$'\e[36m'
COLOR_BLUE=$'\e[38;2;30;144;255m'        # Perfect blue (Python).
COLOR_DIR_BLUE=$'\e[38;2;0;80;255m'      # Dark and crisp blue (Directory).
COLOR_YELLOW=$'\e[38;2;240;219;79m'      # Node.js/JS yellow.
COLOR_RESET=$'\e[0m'

# Update vcs_info, go, python and node versions before each prompt.
precmd() {
  vcs_info

  local -a active_langs

  if command -v go >/dev/null 2>&1; then
      local go_version=$(go version 2>/dev/null)
      if [[ "${go_version}" =~ "go([0-9]+\.[0-9]+(\.[0-9]+)?)" ]]; then
          active_langs+=("%{${COLOR_CYAN}%}go▶${match[1]}%{${COLOR_RESET}%}")
      fi
  fi

  if command -v node >/dev/null 2>&1; then
      local node_version=$(node --version 2>/dev/null)
      if [[ -n "$node_version" ]]; then
          # Strip the leading 'v' (v20.11.0 -> 20.11.0).
          local clean_node_version="${node_version#v}"
          active_langs+=("%{${COLOR_YELLOW}%}node▶${clean_node_version}%{${COLOR_RESET}%}")
      fi
  fi

  if command -v python >/dev/null 2>&1; then
      local py_version=""

      if command -v pyenv >/dev/null 2>&1; then
          py_version=$(pyenv version-name 2>/dev/null)
      fi

      if [[ -z "$py_version" || "$py_version" == "system" ]]; then
          py_version=$(python --version 2>&1 | cut -d' ' -f2)
      fi

      if [[ -n "$py_version" ]]; then
          active_langs+=("%{${COLOR_BLUE}%}py▶${py_version}%{${COLOR_RESET}%}")
      fi
  fi

  lang_info=""
  if (( ${#active_langs[@]} > 0 )); then
      lang_info="${(j:   :)active_langs}"$'\n'
  fi
}

# Nicer prompt.
setopt prompt_subst
export PS1="\${lang_info}%F{green} %*%f %{${COLOR_DIR_BLUE}%}%3~%{${COLOR_RESET}%}\${vcs_info_msg_0_}"$'\n'"%{${COLOR_RESET}%}$ "

# Enable plugins.
plugins=(git brew history kubectl history-substring-search)

# Custom $PATH with extra locations.
export PATH=/opt/homebrew/bin:$HOME/Library/Python/3.12/bin:/usr/local/bin:/usr/local/sbin:$HOME/bin:$HOME/.local/bin:$HOME/go/bin:/usr/local/git/bin:$HOME/.composer/vendor/bin:$PATH

# Bash-style time output.
export TIMEFMT=$'\nreal\t%*E\nuser\t%*U\nsys\t%*S'

# Include alias file (if present) containing aliases for ssh, etc.
if [ -f ~/.aliases ]
then
  source ~/.aliases
fi

# Set architecture-specific brew share path.
arch_name="$(uname -m)"
if [ "${arch_name}" = "x86_64" ]; then
    share_path="/usr/local/share"
elif [ "${arch_name}" = "arm64" ]; then
    share_path="/opt/homebrew/share"
else
    echo "Unknown architecture: ${arch_name}"
fi

# Allow history search via up/down keys.
source ${share_path}/zsh-history-substring-search/zsh-history-substring-search.zsh
bindkey "^[[A" history-substring-search-up
bindkey "^[[B" history-substring-search-down

# Completions.
autoload -Uz compinit && compinit
# Case insensitive.
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*'

# Lifesaving defaults (prompt before overwrite/delete).
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# Colored search outputs.
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'

# Create a directory and immediately enter it.
mkcd() {
  mkdir -p "$1" && cd "$1"
}

# Git upstream branch syncer.
# Usage: gsync master (checks out master, pull upstream, push origin).
gsync() {
 if [[ ! "$1" ]] ; then
     echo "You must supply a branch."
     return 0
 fi

 BRANCHES=$(git branch --list $1)
 if [ ! "$BRANCHES" ] ; then
    echo "Branch $1 does not exist."
    return 0
 fi

 git checkout "$1" && \
 git pull upstream "$1" && \
 git push origin "$1"
}

# Enter a running Docker container.
denter() {
 if [[ ! "$1" ]] ; then
     echo "You must supply a container ID or name."
     return 0
 fi

 docker exec -it $1 bash
 return 0
}

# Fast, temporary containers (auto-remove when stopped).
run-redis() {
    echo "🚀 Starting temporary Redis (Port: 6379)..."
    docker run --rm --name throwaway-redis -p 6379:6379 -d redis:alpine >/dev/null
    echo "✅ Ready! To stop and remove: docker stop throwaway-redis"
}

run-postgres() {
    echo "🐘 Starting temporary Postgres (Port: 5432)..."
    docker run --rm --name throwaway-postgres -e POSTGRES_PASSWORD=postgres -p 5432:5432 -d postgres:alpine >/dev/null
    echo "✅ Ready! (User: postgres, Password: postgres)"
    echo "🛑 To stop and remove: docker stop throwaway-postgres"
}

run-clickhouse() {
    echo "📊 Starting temporary Clickhouse..."
    docker run --rm --name throwaway-clickhouse -p 8123:8123 -p 9000:9000 --ulimit nofile=262144:262144 -d clickhouse/clickhouse-server >/dev/null
    echo "✅ Ready! HTTP: 8123, Native: 9000"
    echo "🛑 To stop and remove: docker stop throwaway-clickhouse"
}

# Tell homebrew to not autoupdate every single time I run it (just once a week).
export HOMEBREW_AUTO_UPDATE_SECS=604800

# Allow Composer to use almost as much RAM as Chrome.
export COMPOSER_MEMORY_LIMIT=-1

# pyenv
eval "$(pyenv init -)"
