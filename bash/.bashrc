# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi



# This variable will hold the Git branch string, with color
GIT_PROMPT_STRING="\$(if [ -n \"\$(parse_git_branch)\" ]; then echo \"\[\033[01;33m\](\$(parse_git_branch))\[\033[00m\]\"; fi)"


# This variable will hold the Git branch string, without color
GIT_PROMPT_STRING_NO_COLOR="\$(if [ -n \"\$(parse_git_branch)\" ]; then echo \"(\$(parse_git_branch))\"; fi)"



if [ "$color_prompt" = yes ]; then

# PS1='\[\033[01;32m\]\u\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$'

 PS1="\[\033[01;32m\]\u\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]${GIT_PROMPT_STRING}\\$ "

else

#    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '

PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w'"${GIT_PROMPT_STRING_NO_COLOR}"'\\$ '

fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)

#    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"

 PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"

    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi




#CONSERVATINO MODE SHORTCUTS
alias csm1='echo 1 | sudo tee /sys/bus/platform/drivers/ideapad_acpi/VPC2004:00/conservation_mode'
alias csm0='echo 0 | sudo tee /sys/bus/platform/drivers/ideapad_acpi/VPC2004:00/conservation_mode'
alias csmstat='cat /sys/bus/platform/drivers/ideapad_acpi/VPC2004:00/conservation_mode'


#OBSIDIAN SHORTCUTS
alias obsidian='flatpak run md.obsidian.Obsidian'


# Alias to launch Jupyter Notebook from virtual environment
alias openjn='source ~/.virtualenvs/jupyter_env/bin/activate && jupyter notebook'


#Terminal Directory shortcuts
alias openphp='cd /var/www/html'
. "$HOME/.cargo/env"


# Alias for opening Config files
alias openconfig='cd ~/dotfiles/config/.config'


# Alias for opening thesis 
function openthesis() {


    # Define the project directory path for easier use
    local proj_dir="$HOME/Two-Steep-Ahead"
    # Define a log file inside the backend directory
    local log_file="$proj_dir/backend/server.log"

    cd "$proj_dir" && \

    # 1. Change to the project directory. Using ~/ assumes it's in your home folder.
    # The '&&' means the next command will only run if the 'cd' is successful.
    # cd ~/Two-Steep-Ahead && \

    # 2. Activate the virtual environment
    source venv/bin/activate && \

    # 3. Open VSCodium in the background (the '&' is important)
    echo "Opening VSCodium..."
    codium . & \



    # This is the key change: redirect stdout and stderr to the log file
#    nohup python3 backend/server.py > "$log_file" 2>&1 &

#    echo "Server is running detached. Use 'tail -f' to see logs."

    # 4. Start the Python server in the background (the '&' is important)
    # echo "Starting Python backend server..."
    # nohup python3 backend/server.py > /dev/null 2>&1 &

    # echo "Server is now running fully detached in the background."

    # Optional: A message to confirm everything is running
}


# Alias for show all aliases
function cheatsheet() {
    # This is the config file. Change to ~/.zshrc if you use Zsh.
    local config_file="$HOME/.bashrc"

    echo "--- My Custom Aliases ---"
    # Grep for lines starting with 'alias', then format into columns.
    grep '^alias' "$config_file" | column -t -s '='

    echo -e "\n--- My Custom Functions ---"
    # Grep for lines starting with 'function' to show their names.
    grep '^function' "$config_file"
}


parse_git_branch() {
  git branch --show-current 2>/dev/null
}


function stop_tsa() {
    # Define the port your server runs on
    local port=5000
    echo "Attempting to stop server on port ${port}..."

    # lsof -t gives only the PID, which is perfect for scripting.
    # The output is captured into the 'pids' variable.
    local pids=$(lsof -t -i :${port})

    # Check if the 'pids' variable is empty
    if [ -z "$pids" ]; then
        echo "No server found running on port ${port}."
        return 1 # Fails with an error code
    else
        echo "Found server process(es) with PID(s): $pids"
        # Use kill -9 for a forceful stop, which is often necessary
        # for stubborn development servers.
        kill -9 $pids
        echo "Kill signal sent. Server on port ${port} should be stopped."
        return 0 # Succeeds
    fi
}
