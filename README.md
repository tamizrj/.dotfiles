# tamizrj dotfiles

Unix config files, meant to be copied into home directory via GNU Stow

## setup
- install [homebrew](https://brew.sh)
    - up-to-date CLI packages
- then:
```sh
brew bundle
(cd ~/.dotfiles && stow .)
```

## TODOs:
- [ ] fish prompt showing git modification
- [ ] fish aliases
    - mygpp, cse for ssh (or alias in .ssh/config?)
- [ ] clean up bashrc
- [ ] switch macos to bash as login shell, get rid of zsh stuff ()
    - "zsh stuff" is omz and p10k
- [ ] dotsync fish function
    - basically git pull, maybe abort on merge commit
    - ff-only ?

