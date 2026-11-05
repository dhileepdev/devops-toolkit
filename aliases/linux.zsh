# devops-toolkit aliases — Linux version
# Source this from your .bashrc or .zshrc:
#   source /path/to/devops-toolkit/aliases/linux.zsh

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

# ---- Docker shortcuts ----
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
eval $(thefuck --alias) 2>/dev/null || true
alias f="thefuck"

# ---- Quick network checks ----
alias myip="curl -s ifconfig.me || curl -s ipinfo.io/ip"
alias ports="ss -tlnp"

# ---- System overview ----
alias mem="free -h"
alias cpu="top -bn1 | head -n 20"
alias disk="df -h"

# ---- Quick edit this repo ----