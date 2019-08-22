#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Vi all the things
set -o vi
# But make sure ^L, ^A, and ^E still work when in insert mode (muscle memory)
bind -m vi-insert "\C-l":clear-screen
bind -m vi-insert "\C-a":beginning-of-line
bind -m vi-insert "\C-e":end-of-line

# Locale
export LANG='en_US.UTF-8'
export LC_ALL='en_US.UTF-8'

# I type these things a lot
alias grep='grep --color'
alias vi='vim'
alias t='todo'
alias ll='ls -lh'
alias r='ranger'
alias tc='tabs -16 ; tcalc '
alias op='netstat -tanl | grep LISTEN | grep tcp4 | sort'

if [ -n "$WAYLAND_DISPLAY" ]; then
	alias xc='wl-copy'
	alias xp='wl-paste'
else
	alias xc='xclip -selection clipboard'
	alias xp='xclip -selection clipboard -o'
fi

# Python has some very handy treats
alias http='python3 -m http.server'
alias json='python3 -m json.tool'

# Quick AES encryption/decryption
alias enc='openssl aes-256-cbc -salt'
alias dec='openssl aes-256-cbc -d -salt'

if [ "`uname`" = "Linux" ]; then
	alias ls='ls --color'
	alias open='xdg-open'

	# Look for an active X display
	if [ -z "$DISPLAY" -a "`pgrep xinit`" != "" ]; then
		export DISPLAY=:0
	fi

	# Look for an active SSH agent - we lose it in tmux juggling sometimes.
	# If one isn't found, start it.
	pid="`pgrep ssh-agent`"
	if [ -n "$pid" ]; then
		export SSH_AGENT_PID=$pid
		dir=`/bin/ls -d1 /tmp/ssh-*/agent* | head -n 1`
		export SSH_AUTH_SOCK=$dir
	else
		eval `ssh-agent`
	fi

	# Look for the Sway IPC socket - we lose it in tmux juggling.
	pid=`pgrep -x sway`
	if [ -n "$pid" ]; then
		export SWAYSOCK=/run/user/`id -u`/sway-ipc.`id -u`.$pid.sock

		# Yep, you guessed it - we also lose the DBus session.
		ds=`xargs -n 1 -0 < /proc/$pid/environ | grep DBUS_SESSION_BUS_ADDRESS`
		if [ "$ds" ]; then
			eval export $ds
		fi
		unset ds
	fi
else
	alias ls='ls -G'
	alias firefox='open -a Firefox'

	# Colorize Mac/BSD ls output
	export CLICOLOR=1
	export LSCOLORS=ExGxFxdxCxDxDxBxBxacac
fi

export PATH=$PATH:$HOME/bin:$HOME/.local/bin:/usr/local/sbin

# Perl
export PATH=$PATH:/usr/bin/vendor_perl

# Ruby
export PATH=$PATH:$HOME/.gem/ruby/1.9.1/bin:$HOME/.gem/ruby/2.0.0/bin

# Node
export PATH=$PATH:$HOME/node_modules/.bin
if [ "`uname`" = "Darwin" ]; then
	export NODE_PATH=/usr/local/lib/node_modules
fi

# Go
export GOPATH=~/go
export PATH=$PATH:$GOPATH/bin

# Android
export PATH=$PATH:$HOME/android/tools:$HOME/android/platform-tools
export ANDROID_HOME=/usr/local/opt/android-sdk

# Preferred applications
export EDITOR=vim
export PAGER=less
export BROWSER=firefox
export TERMINAL=alacritty

# Ask Firefox to enable Wayland support
export MOZ_ENABLE_WAYLAND=1

# Some apps (eg: Electron) need this for Sway's system tray.
[ -n "$WAYLAND_DISPLAY" ] && export XDG_CURRENT_DESKTOP=Unity

# tmux / color terms
export TERM=xterm-256color
[ -n "$TMUX" ] && export TERM="screen-256color"

PS1='[\u@\h \W]\$ '

