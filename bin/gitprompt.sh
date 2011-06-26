#!/bin/bash
if [ "$DNS" == "" ]; then
  # Set the (color) term to user@host [dir](branch)
  PS1='\[\033[00;32m\]\u@\h\[\033[00m\] [\[\033[01;34m\]\w\[\033[00m\]]$(__git_ps1 "(%s)")# '
else
  # Set the (color) term to user@DNS [dir]
  PS1='\[\033[00;32m\]\u@$DNS\[\033[00m\] [\[\033[01;34m\]\w\[\033[00m\]]$(__git_ps1 "(%s)"# '
fi

