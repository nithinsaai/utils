# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"

plugins=(
            git
            zsh-autosuggestions
            zsh-syntax-highlighting
            zsh-completions
            sudo
            web-search
            copyfile
            dirhistory
            dirpersist
            history
            jsontools
)

source $ZSH/oh-my-zsh.sh
