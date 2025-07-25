# ~/.bash_prompt: sourced from .bash_profile to construct our prompt.

# Set our epic prompt!
if [[ ! -t 1 ]]; then
  : No prompt needed.
elif [ ! -x "$(command -v tput)" ]; then
  PS1="\u@\h:\w\$ ";
elif [ -f "/etc/bash_prompt_local.sh" ]; then
  PS1="$(source "/etc/bash_prompt_local.sh" 2>/dev/null)";
else
  PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ ';
fi
