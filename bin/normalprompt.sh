#!/bin/bash
if [ "$DNS" == "" ]; then
  # Set the (color) term to user@host [dir]
  PS1='\[\033[00;32m\]\u@\h\[\033[00m\] [\[\033[01;34m\]\w\[\033[00m\]]# '
else
  # Set the (color) term to user@DNS [dir]
  PS1='\[\033[00;32m\]\u@$DNS\[\033[00m\] [\[\033[01;34m\]\w\[\033[00m\]]# '
fi

