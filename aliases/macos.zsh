# devops-toolkit aliases — macOS version
# Source this from your .zshrc:
#   source /path/to/devops-toolkit/aliases/macos.zsh

# ---- Directory aliases ----
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

# ---- Git shortcuts ----
alias g="git"
alias ga="git add"
alias gc="git commit -m"
alias gp="git push"
alias gpl="git pull"
alias gs="git status"
alias gd="git diff"
alias gl="git log --oneline -10"

# ---- Kubectl shortcuts ----
alias k="kubectl"
alias kg="kubectl get"
alias kd="kubectl describe"
alias ka="kubectl apply -f"
alias kdel="kubectl delete"
alias kl="kubectl logs"
alias kr="kubectl rollout restart"

# ---- Helm shortcuts ----
alias h="helm"
alias hd="helm delete"
alias hi="helm install"
alias hu="helm upgrade"
alias hst="helm status"

# ---- Docker shortcuts
alias d="docker"
alias dk="docker"
alias dki="docker image"
alias dkps="docker ps"
alias dkrm="docker rm"
alias dkrb="docker rmi"
alias dklo="docker login"

# ---- fzf / bat / delta integration ----
alias c="bat"
alias cb="bat --plain --color=always"
alias preview="bat --style=numbers --color=always"

# ---- TheFuck alias ----
# Fix last command (requires thefuck installed)
eval $(thefuck --alias) 2>/dev/null || true
alias f="thefuck"

# ---- Quick network checks ----
alias ip="ifconfig"
alias myip="curl -s ifconfig.me"
alias ports="lsof -i -P -n | grep LISTEN"

# ---- System overview
alias mem="vm_stat"
alias cpu="top -l 1 | head -n 20"
alias disk="df -h"

# ---- Quick edit this repo ----
alias dotfiles="cd /Users/dhileep/Desktop/Repos/Personal/devops-toolkit"