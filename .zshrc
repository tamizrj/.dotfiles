# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export CLICOLOR=1

source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme

# my zID
_SSHFS_ZID=z5592097
# my desired mountpoint for my CSE home directory
_SSHFS_CSE_MOUNT="$HOME/cse"

alias csemnt="sshfs -o idmap=user -C ${_SSHFS_ZID}@login${_SSHFS_ZID: -1}.cse.unsw.edu.au: ${_SSHFS_CSE_MOUNT}"
alias cseumnt="umount -f ${_SSHFS_CSE_MOUNT}"
alias csefresh="cseumnt && csemnt"
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME'

function cse() {
    local mypath=$(realpath $PWD)
    # determine where we are relative to the mountpoint (thanks @ralismark)
    local rel=${mypath##${_SSHFS_CSE_MOUNT}}

    if [ -z "$1" ]; then
        # if we don't have arguments, we give the user a shell on the remote cse machine.
        if [ "$mypath" = "$rel" ]; then
            # in the case that we're not in our mountpoint, provide a shell in their home directory.
            ssh "${_SSHFS_ZID}@login${_SSHFS_ZID: -1}.cse.unsw.edu.au"
        else
            # if within the mountpoint, cd to the equivalent dir on the remote before providing a shell (thanks @ralismark)
            ssh "${_SSHFS_ZID}@login${_SSHFS_ZID: -1}.cse.unsw.edu.au" -t "cd $(printf "%q" "./$rel"); exec \$SHELL -l"
        fi
    else
        # if we have arguments, we have a command to execute.
        if [ "$mypath" = "$rel" ]; then
            # in the case that we're not in our mountpoint, we'll execute in the home directory.
            ssh -qt "${_SSHFS_ZID}@login${_SSHFS_ZID: -1}.cse.unsw.edu.au" "$@"
        else
            # if within the mountpoint, cd to the equivalent dir on the remote before executing (thanks @ralismark)
            ssh "${_SSHFS_ZID}@login${_SSHFS_ZID: -1}.cse.unsw.edu.au" -qt "cd $(printf "%q" "./$rel") && $(printf "%q " "$@")"
        fi
    fi
}

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
export JAVA_HOME=/Library/Java/JavaVirtualMachines/openjdk-17.jdk/Contents/Home
alias myclang++="clang++ -std=c++20"

path+="/opt/gradle/gradle-8.8/bin"
path+="/opt/homebrew/opt/openjdk@17/bin"
path+="/Users/tamizrj/.opencode/bin"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
