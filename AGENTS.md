# AGENTS.md

Personal dotfiles for `tamizrj`, applied to `$HOME` with GNU Stow. The repo root is the stow directory, and live files under `~` are symlinks pointing back into it (`~/.bashrc -> .dotfiles/dot-bashrc`). **Edit files in the repo, never the symlinked live files.**

## Apply / verify

- Apply to `$HOME`: `cd ~/.dotfiles && stow .` (idempotent). After adding/renaming/deleting files, re-run it (`stow -R .`) or the new files won't be live.
- Fresh setup: `brew bundle`, then `stow .`.
- `.stowrc` supplies `--no-folding --dotfiles --verbose`: `dot-foo` → `~/.foo`, `dot-config/x` → `~/.config/x`. `.stow-local-ignore` excludes `README*`/`LICENSE*`/`AGENTS.md`/`.git`/`.DS_Store`/stow files, but `Brewfile` **is** stowed (creates `~/Brewfile`).
- Syntax-check fish files: `fish --no-execute <file>`.
- No CI, linters, or git hooks — verification is manual.
- Commit style (consistent across history): lowercase conventional-ish with tool scope — `update(fish): ...`, `feat(nvim): ...`, `fix(fish): ...`, `chore:`, `refactor:`, `add:`.

## Layout

- **dot-config/nvim/** — self-contained config with its own `AGENTS.md` (plugin system, conventions, verification). Follow that file for nvim work.
- **dot-config/fish/** — the interactive shell: `conf.d/abbrs.fish` (abbreviations + aliases), `functions/` (prompt). `config.fish` only sets `fish_transient_prompt`.
- **dot-shrc** — POSIX helpers (`mygpp`, `cse`, ls aliases) sourced by both `dot-bashrc` and `dot-zshrc`; also sources machine-local `~/.localrc` if present.
- **dot-zshrc / dot-p10k.zsh** — legacy macOS/omz/p10k setup slated for removal (README TODO) — don't expand it.
- **dot-config/git/** — `config` plus `config-uni` (pulled by `includeIf "gitdir/i:**/uni/**"`, uni credentials). `core.excludesfile` points at `~/.config/git/.global_gitignore`, which is machine-local and **not** tracked here.
- **dot-config/ghostty/** — terminal config; its `command` probes fish at `/opt/homebrew`, `/home/linuxbrew`, `/usr/bin`, then PATH, so it works on both macOS and Linux.
- **dot-editorconfig / dot-clang-format** — formatting defaults; nvim symlinks them into `~` at startup.
- **Brewfile** — source of truth for installed tools (stow, fish, neovim, ripgrep, fd, fzf).
- **README.md TODOs are partly stale**: the fish git prompt and fish aliases are already implemented; only zsh cleanup remains.

## Fish right prompt (async)

- The right prompt is drawn **manually on line 1 of `fish_prompt.fish`**, which calls `custom_right_prompt`. There is no `fish_right_prompt`; fish only positions a native right prompt on the prompt's *last* line, so this code right-aligns itself with `\r\e[<col>G`. To change the right-side content, edit `custom_right_prompt`.
- The git segment is computed **out-of-band**, because fish's `fish_vcs_prompt` spawns several git subprocesses (~100ms per render). `custom_right_prompt` renders a cached value and calls `__custom_right_prompt_kick`, which runs `__custom_right_prompt_async` in a background fish. That job writes `seq\ncwd\nsegment` to a temp file and sends `SIGUSR1`; `__custom_right_prompt_update` applies it and repaints, ignoring stale `seq`/`cwd`. Keep these in **separate function files** — the background fish re-autoloads them by name from `functions/`.
- Keep prompt code portable across macOS and Linux (GNU vs BSD differ): use a `mktemp <dir>/name.XXXXXX` template (not `mktemp -t`), and `(status fish-path)` (not a bare `fish`) to launch the background shell.
- `fish_transient_prompt 1` (set in `config.fish`) makes `fish_prompt` short-circuit on `--final-rendering` to emit a bare `↪ `. Keep that branch: without it, old prompts can't realign on terminal resize.
- `~/.config/fish/fish_variables` (universal `set -U` state) is machine-local and deliberately untracked — changes there never belong in this repo.

## Portability (macOS + Linux Mint)

- Target both; prefer portable forms. Known macOS-only item: `conf.d/abbrs.fish` `pp`/`pi` use `pbpaste` (no Linux equivalent — would need `xclip`/`wl-paste`). `dot-zshrc` (`/opt/homebrew`, `/Library/Java/...`) is macOS-only but legacy.
