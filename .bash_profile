# Git completion, from git/contrib/completion
source .git-completion.bash

# Alias git to "hub", the github-happy version!
alias git='hub'

GIT_PS1_SHOWDIRTYSTATE='yesplz'

# Set the (color) term to user@host:dir
PS1='\[\033[00;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

# Make ls use colors
alias ls='ls -G'
# Aliases for common ls shortcuts
alias l='ls'
alias ll='ls -l'
alias la='ls -A'

# Turn the git prompt on and off
alias giton='source ~/bin/gitprompt.sh'
alias gitoff='source ~/bin/normalprompt.sh'

# Show on the first hit of tab, even if it is ambiguous, instead
# of making me hit tab twice
bind "set show-all-if-ambiguous on" 
# Ignore case on completion matches
bind "set completion-ignore-case on"

export PATH=$PATH:~/bin

# Temporary: add msp430 binutils/gcc to path
export PATH=$PATH:/opt/msp430-gcc-4.4.5/bin

# Use git achievements!
alias gita=git-achievements
