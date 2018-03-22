# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples
# We use preexec and precmd hook functions for Bash
# If you have anything that's using the Debug Trap or PROMPT_COMMAND 
# change it to use preexec or precmd
# See also https://github.com/rcaloras/bash-preexec

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

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

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

# If this is an xterm set more declarative titles 
# "dir: last_cmd" and "actual_cmd" during execution
# If you want to exclude a cmd from being printed see line 156
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\$(print_title)\a\]$PS1"
    __el_LAST_EXECUTED_COMMAND=""
    print_title () 
    {
        __el_FIRSTPART=""
        __el_SECONDPART=""
        if [ "$PWD" == "$HOME" ]; then
            __el_FIRSTPART=$(gettext --domain="pantheon-files" "Home")
        else
            if [ "$PWD" == "/" ]; then
                __el_FIRSTPART="/"
            else
                __el_FIRSTPART="${PWD##*/}"
            fi
        fi
        if [[ "$__el_LAST_EXECUTED_COMMAND" == "" ]]; then
            echo "$__el_FIRSTPART"
            return
        fi
        #trim the command to the first segment and strip sudo
        if [[ "$__el_LAST_EXECUTED_COMMAND" == sudo* ]]; then
            __el_SECONDPART="${__el_LAST_EXECUTED_COMMAND:5}"
            __el_SECONDPART="${__el_SECONDPART%% *}"
        else
            __el_SECONDPART="${__el_LAST_EXECUTED_COMMAND%% *}"
        fi 
        printf "%s: %s" "$__el_FIRSTPART" "$__el_SECONDPART"
    }
    put_title()
    {
        __el_LAST_EXECUTED_COMMAND="${BASH_COMMAND}"
        printf "\033]0;%s\007" "$1"
    }
    
    # Show the currently running command in the terminal title:
    # http://www.davidpashley.com/articles/xterm-titles-with-bash.html
    update_tab_command()
    {
        # catch blacklisted commands and nested escapes
        case "$BASH_COMMAND" in 
            *\033]0*|update_*|echo*|printf*|clear*|cd*)
            __el_LAST_EXECUTED_COMMAND=""
                ;;
            *)
            put_title "${BASH_COMMAND}"
            ;;
        esac
    }
    preexec_functions+=(update_tab_command)
    ;;
*)
    ;;
esac


export PYTHONSTARTUP=~/.pythonrc

export http_proxy='http://proxy61.iitd.ac.in:3128'
export https_proxy='http://proxy61.iitd.ac.in:3128'
export ftp_proxy='http://proxy61.iitd.ac.in:3128'
export all_proxy="http://proxy61.iitd.ac.in:3128"
#export LDFLAGS="-shared"

#export PS1='\[\e]0;\h:\w\a\][\[$(tput setaf 0)\]\[\e[37m\]\u@\h \[\e[34m\]\w\[\e[0m\]]\n\$ '
export PS1='\[\e]0;\h:\w\a\][\[$(tput setaf 0)\]\[\e[34m\]\u@\h \[\e[34m\]\w\[\e[0m\]]\n\$ '

# some more ls aliases

alias piplist='pip freeze'
alias downloadserver='ssh -X asz148030@download.iitd.ac.in'
alias shivphd='ssh -X asz178027@hpc.iitd.ac.in'
alias sikkapa='ssh -X asz138508@10.233.24.2'
alias sikkapu='ssh -X asz148030@10.233.24.2'
alias hpcashu='ssh -X ast142287@hpc.iitd.ac.in'
alias c='clear'
alias hpcshiv='ssh -X ast152068@hpc.iitd.ac.in'
alias hpcashuird='ssh -X ashu2203.cstaff@hpc.iitd.ac.in'
alias hpcanu='ssh -X asz168368@hpc.iitd.ac.in'
alias hpccharu='ssh -X asz138015@hpc.iitd.ac.in'
alias dilipst='ssh -X dilip@10.233.24.5'
alias dilipsys='ssh -X dilip@10.233.24.115'
alias hpcpu='ssh -X asz148030@hpc.iitd.ac.in'
alias hpcpa='ssh -X asz138508@hpc.iitd.ac.in'
alias chpu="ssh -X 2014asz8030@10.233.24.3"
alias stpu="ssh -X 2014asz8030@10.233.24.5"
alias stpa="ssh -X 2013asz8508@10.233.24.5"
alias shivst='ssh -X 2015ast2068@10.233.24.5'
alias ashust='ssh -X 2014ast2287@10.233.24.5'
alias spro="source $HOME/.profile"
alias sbr="source $HOME/.bashrc"
alias sbp="source $HOME/.bash_profile"
alias editbash="vi $HOME/.bashrc"
alias editbashprofile="vi $HOME/.bash_profile"
alias editprofile="vi $HOME/.profile"
alias space='du -ch | grep total'
alias cp='cp -i'
alias mv='mv -i'
alias wget='wget --continue --no-check-certificate'
alias firefox='firefox &'
alias lst='ls -lrt'
alias vi='vim'
alias count_files='ls | wc -l'
alias ls='ls -hN --color=auto --group-directories-first'
alias mkdir="mkdir -pv"
alias pawan='ssh -X pawan@10.233.104.254'
alias update='sudo apt-get update && sudo apt-get upgrade && sudo apt-get dist-upgrade && sudo apt-get clean && sudo apt-get autoclean && sudo apt-get autoremove'
alias cdat='source activate uvcdat2_12'
alias cdat3='source activate cdat.3.0.beta'
alias dilip1='ssh -X dilip1@10.233.24.6'
alias dilip2='ssh -X dilip2@10.233.24.6'
alias dilip3='ssh -X dilip3@10.233.24.6'
alias dilip4='ssh -X dilip4@10.233.24.6'
alias amithpc='ssh -X amit04.cstaff@hpc.iitd.ac.in'
alias puneet='ssh -X puneet@10.233.24.249'

# Eternal bash history.
# ---------------------
# Undocumented feature which sets the size to "unlimited".
# http://stackoverflow.com/questions/9457233/unlimited-bash-history
export HISTFILESIZE=
export HISTSIZE=
export HISTTIMEFORMAT="[%F %T] "
# Change the file location because certain bash sessions truncate .bash_history file upon close.
# http://superuser.com/questions/575479/bash-history-truncated-to-500-lines-on-each-login
export HISTFILE=~/.bash_eternal_history
# Force prompt to write history after every command.
# http://superuser.com/questions/20900/bash-history-loss
PROMPT_COMMAND="history -a; $PROMPT_COMMAND"

# don't put duplicate lines in the history. See bash(1) for more options
HISTCONTROL=ignoredups
# ... and ignore same sucessive entries.
HISTCONTROL=ignoreboth



#-------------------------------------------------------------
# Greeting, motd etc. ...
#-------------------------------------------------------------

# Color definitions (taken from Color Bash Prompt HowTo).
# Some colors might look different of some terminals.
# For example, I see 'Bold Red' as 'orange' on my screen,
# hence the 'Green' 'BRed' 'Red' sequence I often use in my prompt.


# Normal Colors
Black='\e[0;30m'        # Black
Red='\e[0;31m'          # Red
Green='\e[0;32m'        # Green
Yellow='\e[0;33m'       # Yellow
Blue='\e[0;34m'         # Blue
Purple='\e[0;35m'       # Purple
Cyan='\e[0;36m'         # Cyan
White='\e[0;37m'        # White

# Bold
BBlack='\e[1;30m'       # Black
BRed='\e[1;31m'         # Red
BGreen='\e[1;32m'       # Green
BYellow='\e[1;33m'      # Yellow
BBlue='\e[1;34m'        # Blue
BPurple='\e[1;35m'      # Purple
BCyan='\e[1;36m'        # Cyan
BWhite='\e[1;37m'       # White

# Background
On_Black='\e[40m'       # Black
On_Red='\e[41m'         # Red
On_Green='\e[42m'       # Green
On_Yellow='\e[43m'      # Yellow
On_Blue='\e[44m'        # Blue
On_Purple='\e[45m'      # Purple
On_Cyan='\e[46m'        # Cyan
On_White='\e[47m'       # White

NC="\e[m"               # Color Reset


function extract()      # Handy Extract Program
{
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)   tar -xvjf $1     ;;
            *.tar.gz)    tar -xvzf $1     ;;
            *.bz2)       bunzip2 $1      ;;
            *.tar.bz2)   tar -jxf $1      ;;
            *.rar)       unrar x $1      ;;
            *.gz)        gunzip $1       ;;
            *.tar)       tar -xvf $1      ;;
            *.tbz2)      tar -xvjf $1     ;;
            *.tgz)       tar -xvzf $1     ;;
            *.zip)       unzip $1        ;;
            *.Z)         uncompress $1   ;;
            *.7z)        7z x $1         ;;
            *)           echo "'$1' cannot be extracted via >extract<" ;;
        esac
    else
        echo "'$1' is not a valid file!"
    fi
}


alias mount='mount |column -t'


## a quick way to get out of current directory ##
alias .1='cd ..'
alias .2='cd ../../'
alias .3='cd ../../../'
alias .4='cd ../../../../'
alias .5='cd ../../../../../'



## Colorize the grep command output for ease of use (good for log files)##
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

#export LDFLAGS=$LDFLAGS:/usr/lib/x86_64-linux-gnu
#export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib/x86_64-linux-gnu

#export CPPFLAGS="-I/usr/local/uvcdat/2.4.1/Externals/include"
#export LDFLAGS="-L/usr/local/uvcdat/2.4.1/Externals/lib"
#export LD_LIBRARY_PATH="/usr/local/uvcdat/2.4.1/Externals/lib"

#source /usr/local/uvcdat/2.4.1/bin/setup_runtime.sh
#alias cdat='/usr/local/uvcdat/2.4.1/bin//python'
#alias uvcdat='/usr/local/uvcdat/2.4.1/bin//uvcdat'
#alias uvcdscan='/usr/local/uvcdat/2.4.1/bin//cdscan'
#alias uvcddump='/usr/local/uvcdat/2.4.1/bin//cddump'
#alias uvpydoc='/usr/local/uvcdat/2.4.1/bin//pydoc'

#alias py='/usr/bin/python'

#export PYTHONPATH=${PYTHONPATH}:/usr/lib/python2.7/dist-packages:/home/puneet/py_modules/general_py:/home/puneet/py_modules/python_atmos

#--GrADS--#
export GRADS=/home/puneet/all_install/grads/grads-2.0.2
export GADDIR=/home/puneet/all_install/grads/data2
export PATH=$PATH:$GRADS:$GRADS/bin
export GASCRP=/home/puneet/all_install/grads/grads-2.0.2/scripts
#--END GrADS--#


###NCL###
export NCARG_ROOT=/home/puneet/all_install/ncl-6.4.0
export PATH=$NCARG_ROOT/bin:$PATH
###END NCL###

###GNUPLOT###
#export GNUPLOT=/home/puneet/all_install/gnuplot-5.0.3
#export PATH="${GNUPLOT}/bin:${PATH}"
#export LD_LIBRARY_PATH="${GNUPLOT}/lib:${LD_LIBRARY_PATH}"
#export GNUPLOTLIB=${GNUPLOT}/lib
#export GNUPLOTINC=${GNUPLOT}/include
##END GNUPLOT###

###XMGRACE###
#export XMGRACE=/home/puneet/all_install/grace-5.1.25/grace
#export PATH="${XMGRACE}/bin:${PATH}"
#export LD_LIBRARY_PATH="${XMGRACE}/lib:${LD_LIBRARY_PATH}"
#export XMGRACELIB=${XMGRACE}/lib
#export XMGRACEINC=${XMGRACE}/include
##END XMGRACE###


###NETCDF###
#export NETCDF=/home/puneet/miniconda2/envs/uvcdat_2_10
#export PATH="${NETCDF}/bin:${PATH}"
#export LD_LIBRARY_PATH="${NETCDF}/lib:${LD_LIBRARY_PATH}"
#export NETCDFLIB=${NETCDF}/lib
#export NETCDFINC=${NETCDF}/include
##END NETCDF###

###HDF5###
#export HDF5=/home/puneet/miniconda2/envs/uvcdat_2_10
#export PATH="${HDF5}/bin:${PATH}"
#export LD_LIBRARY_PATH="${HDF5}/lib:${LD_LIBRARY_PATH}"
#export HDF5LIB=${HDF5}/lib
#export HDF5INC=${HDF5}/include
##END HDF5###


#export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:/usr/bin:/usr/lib/x86_64-linux-gnu/pkgconfig:/usr/lib/pkgconfig


#alias cdat='/home/puneet/miniconda2/envs/uvcdat_2_6_1/bin//python'
#alias uvcdat-gui='/home/puneet/miniconda2/envs/uvcdat_2_6_1/bin//uvcdat'
#alias uvcdscan='/home/puneet/miniconda2/envs/uvcdat_2_6_1/bin//cdscan'
#alias uvcddump='/home/puneet/miniconda2/envs/uvcdat_2_6_1/bin//cddump'
#alias 'uvcdat-f'='/home/puneet/miniconda2/envs/uvcdat_2_6_1/bin//python -i /home/puneet/.uvcdat_f.py'
#alias ls='ls --hide="*.pyc"'

#export GDAL_DATA=/home/puneet/miniconda2/envs/uvcdat/share/gdal

#export PATH="/usr/local/texlive/2017/bin/x86_64-linux:$PATH"
#export MANPATH="/usr/local/texlive/2017/texmf-dist/doc/man"
#export INFOPATH="/usr/local/texlive/2017/texmf-dist/doc/info"


#LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/home/puneet/miniconda2/envs/uvcdat-2.x.y/lib"

#PYTHONPATH="$PYTHONPATH:/home/puneet/miniconda2/envs/uvcdat-2.x.y/lib/python2.7/site-packages/vtk"


#export CLASSPATH=".:/usr/local/lib/antlr-4.4-complete.jar:$CLASSPATH"
#alias antlr4='java -jar /usr/local/lib/antlr-4.4-complete.jar'
#alias grun='java org.antlr.v4.runtime.misc.TestRig'
#alias cdat='source activate uvcdat_2_10'


# added by Miniconda2 4.3.21 installer
#export PATH="/home/puneet/miniconda2/bin:$PATH"
export PATH="/home/puneet/miniconda2/envs/uvcdat2_12/bin:$PATH"

conda config --set ssl_verify false

export GDAL_DATA=/home/puneet/miniconda2/envs/uvcdat2_12/share/gdal


export PATH="/usr/local/texlive/2017/bin/x86_64-linux:$PATH"

shopt -s autocd #Allows you to cd into directory merely by typing the directory name.


