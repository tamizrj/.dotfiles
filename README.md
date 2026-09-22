# tamizrj dotfiles

Unix config files, meant to be copied into home directory via GNU Stow

## setup
run `(cd ~/.dotfiles && stow .)`

## required tools
- `git`
- `stow` for managing dotfile symlinks
- `nvim` for editing via apt:
```sh
sudo add-apt-repository ppa:neovim-ppa/stable
sudo apt update
sudo apt install neovim
```
- for neovim: `rg` and `fd`
