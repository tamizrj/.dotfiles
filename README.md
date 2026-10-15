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

## roadmap
- [x] fish prompt showing git modification
- [x] fish aliases
    - mygpp, cse for ssh (or alias in .ssh/config?)
- [x] clean up bashrc
- [x] switch macos to bash as login shell, get rid of zsh stuff
    - "zsh stuff" is omz and p10k
- [ ] dotsync fish function
    - basically git pull, maybe abort on merge commit
    - ff-only ?

