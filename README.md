# tamizrj dotfiles

Unix config files, meant to be copied into home directory via GNU Stow

## setup
run `(cd ~/.dotfiles && stow .)`

## required tools
- `git`
- `stow` for managing dotfile symlinks
- `nvim` for editing

for linux, download Appimage
```sh
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.appimage
chmod u+x nvim-linux-x86_64.appimage
./nvim-linux-x86_64.appimage
```
- for neovim: `rg` and `fd`
    - in apt, `sudo apt install fd-find`
