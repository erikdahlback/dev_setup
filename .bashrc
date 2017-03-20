# .bashrc
# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific aliases and functions
#Aliases
alias ll="ls -lhA"
alias ls="ls -CF"

alias mkdir="mkdir -pv"
alias sublime="open -a /Applications/Sublime\ Text.app/"

#Linux 
if [ -f /nfs/home/erikdahlback/dev_setup/git/git-completion.bash ]; then
  echo Linux
  #Git auto complet
  source /nfs/home/erikdahlback/dev_setup/git/git-completion.bash
 
  cd /nfs/home/erikdahlback/
 
  # Global GIt config
  export XDG_CONFIG_HOME=/nfs/home/erikdahlback/dev_setup/

  # Remove firewall entries to enable PVaccess
  echo 'Firewall looks like:'
  sudo iptables -L
  sudo iptables -F INPUT
  sudo iptables -F FORWARD

fi

#MAC
if [ -f /Volumes/erikdahlback/dev_setup/git/git-completion.bash ]; then
 echo MAC 
 source /Volumes/erikdahlback/dev_setup/git/git-completion.bash

 cd /Volumes/erikdahlback/

 # Global GIt config
  export XDG_CONFIG_HOME=/Volumes/erikdahlback/dev_setup/

fi

#Prompt
# get current branch in git repo
function parse_git_branch() {
	BRANCH=`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
	if [ ! "${BRANCH}" == "" ]
	then
		STAT=`parse_git_dirty`
		echo "[${BRANCH}${STAT}]"
	else
		echo ""
	fi
}

# get current status of git repo
function parse_git_dirty {
	status=`git status 2>&1 | tee`
	dirty=`echo -n "${status}" 2> /dev/null | grep "modified:" &> /dev/null; echo "$?"`
	untracked=`echo -n "${status}" 2> /dev/null | grep "Untracked files" &> /dev/null; echo "$?"`
	ahead=`echo -n "${status}" 2> /dev/null | grep "Your branch is ahead of" &> /dev/null; echo "$?"`
	newfile=`echo -n "${status}" 2> /dev/null | grep "new file:" &> /dev/null; echo "$?"`
	renamed=`echo -n "${status}" 2> /dev/null | grep "renamed:" &> /dev/null; echo "$?"`
	deleted=`echo -n "${status}" 2> /dev/null | grep "deleted:" &> /dev/null; echo "$?"`
	bits=''
	if [ "${renamed}" == "0" ]; then
		bits=">${bits}"
	fi
	if [ "${ahead}" == "0" ]; then
		bits="*${bits}"
	fi
	if [ "${newfile}" == "0" ]; then
		bits="+${bits}"
	fi
	if [ "${untracked}" == "0" ]; then
		bits="?${bits}"
	fi
	if [ "${deleted}" == "0" ]; then
		bits="x${bits}"
	fi
	if [ "${dirty}" == "0" ]; then
		bits="!${bits}"
	fi
	if [ ! "${bits}" == "" ]; then
		echo " ${bits}"
	else
		echo ""
	fi
}

export PS1="\[\e[33m\]\h\[\e[m\]:\[\e[32m\]\u\[\e[m\]:\`parse_git_branch\`:\[\e[35m\]\w\[\e[m\]\\$ "

