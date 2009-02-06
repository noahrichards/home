# Turn "git mode" on
parse_git_branch() 
{
      git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

PS1='\[\033[00;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w$(parse_git_branch)\[\033[00m\]\$ '
