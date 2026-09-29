# tamizrj dotfiles

Unix config files, meant to be copied into home directory via GNU Stow

## setup
run `(cd ~/.dotfiles && stow .)`

## required tools
- `git`
- `fish` shell (cause awesome)
    - with apt, download from ppa:
```sh
sudo add-apt-repository ppa:fish-shell/release-4
apt update
apt install fish
```
- `stow` for managing dotfile symlinks
- `nvim` for editing
    - instead of apt, download via AppImage (below)
    - alternatives are brew, snap, or unstable ppa (all annoying)
```sh
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.appimage
chmod u+x nvim-linux-x86_64.appimage
# below is optional
mv nvim-linux-x86_64.appimage ~/.local/bin/
fish_add_path ~/.local/bin/
nvim
```
- for neovim pickers: `rg` and `fd`
    - in apt, `sudo apt install fd-find`

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
- [ ] nvim show file icons on file picker

