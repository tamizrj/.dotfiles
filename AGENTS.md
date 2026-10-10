# AGENTS.md

Personal dotfiles for `tamizrj`, applied to `$HOME` with GNU Stow. The repo root is the stow directory, and live files under `~` are symlinks pointing back into it (`~/.bashrc -> .dotfiles/dot-bashrc`). **Edit files in the repo, never the symlinked live files.**

## Apply / verify

- Apply to `$HOME`: `cd ~/.dotfiles && stow .` (idempotent). Use `stow -R .` after deleting/renaming files. Fresh setup: `brew bundle`, then `stow .`.
- `.stowrc` supplies `--dotfiles --no-folding --verbose`: `dot-foo` → `~/.foo`, `dot-config/x` → `~/.config/x`. `.stow-local-ignore` excludes README/LICENSE/`.git`/`.stowrc`, but note `Brewfile` **is** stowed (creates `~/Brewfile`).
- Syntax-check fish files with `fish --no-execute functions/<file>.fish`.
- Commit style (consistent across history): lowercase conventional-ish with tool scope — `update(fish): ...`, `feat(nvim): ...`, `fix:`, `chore:`, `docs:`, `refactor:`.

## Layout

- **dot-config/nvim/** — self-contained config with its own `AGENTS.md` (plugin system, conventions, verification). Follow that file for nvim work.
- **dot-config/fish/** — the interactive shell: `conf.d/abbrs.fish` (abbreviations + aliases), `functions/` (prompt functions).
- **dot-bashrc / dot-shrc / dot-zshrc / dot-p10k.zsh** — shell configs; `dot-shrc` holds shared POSIX helpers (`mygpp`, `cse`, ls aliases). zsh/p10k is legacy slated for removal (README TODO) — don't expand it.
- **dot-config/git/** — git config, with `includeIf gitdir:**/uni/**` pulling `config-uni` (uni credentials).
- **dot-config/ghostty/** — terminal config; launches fish via a path lookup that must work on both macOS (`/opt/homebrew`) and Linux (`/home/linuxbrew`, `/usr/bin`).
- **dot-editorconfig / dot-clang-format** — formatting defaults; nvim symlinks them into `~` at startup.
- **Brewfile** — source of truth for installed tools (stow, fish, neovim, ripgrep, fd, fzf).

## Fish-prompt gotchas

- The right prompt is drawn **manually on line 1 of `fish_prompt.fish`**, which calls `custom_right_prompt` (`functions/custom_right_prompt.fish`, autoloaded by name). There is no `fish_right_prompt`; fish only positions a real right prompt on the prompt's last line, so this prompt does the alignment itself. To change the right-side content, edit `custom_right_prompt`.
- `fish_transient_prompt 1` (set in `config.fish`) makes `fish_prompt` short-circuit on `--final-rendering` to push a bare `↪ ` to scrollback instead of the 2-line prompt. Keep that branch: without it, old prompts can't realign on terminal resize.
- `~/.config/fish/fish_variables` (universal `set -U` state) is machine-local and deliberately untracked — changes there never belong in this repo.