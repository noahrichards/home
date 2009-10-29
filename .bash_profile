# Git completion, from git/contrib/completion
source .git-completion.bash

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

test -r /sw/bin/init.sh && . /sw/bin/init.sh

##
# Your previous /Users/noah/.bash_profile file was backed up as /Users/noah/.bash_profile.macports-saved_2009-09-27_at_13:14:59
##

# MacPorts Installer addition on 2009-09-27_at_13:14:59: adding an appropriate PATH variable for use with MacPorts.
export PATH=/opt/local/bin:/opt/local/sbin:$PATH
# Finished adapting your PATH environment variable for use with MacPorts.

