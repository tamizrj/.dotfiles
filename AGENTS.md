# AGENTS.md

Personal dotfiles for `tamizrj`, applied to `$HOME` with GNU Stow. The repo root is the stow directory, and live files under `~` are symlinks pointing back into it (`~/.bashrc -> .dotfiles/dot-bashrc`). **Edit files in the repo, never the symlinked live files** — this includes `~/.ssh/config` (→ `dot-ssh/config`) and `~/Brewfile`.

## Apply / verify

- Apply to `$HOME`: `cd ~/.dotfiles && stow .` (idempotent). After adding/renaming/deleting files, re-run it (`stow -R .`) or the new files won't be live.
- `.stowrc` supplies `--no-folding --dotfiles --verbose`: `dot-foo` → `~/.foo`, `dot-config/x` → `~/.config/x`. `.stow-local-ignore` excludes `README*`/`LICENSE*`/`AGENTS.md`/`.git`/`.DS_Store`/stow files **and `Brewfile`** — `~/Brewfile` is a pre-ignore leftover symlink, not stow-managed. Fresh setup: `brew bundle --file ~/.dotfiles/Brewfile`, then `stow .`.
- Syntax-check fish files: `fish --no-execute <file>` (silent = OK).
- No CI, linters, or git hooks — verification is manual.
- Commit style (consistent across history): lowercase conventional-ish with tool scope — `update(fish): ...`, `feat(nvim): ...`, `fix(fish): ...`, `chore:`, `refactor:`, `add:`.

## Layout

- **dot-config/nvim/** — self-contained config with its own `AGENTS.md` (plugin system, conventions, verification). Follow that file for nvim work.
- **dot-config/fish/** — the interactive shell: `conf.d/abbrs.fish` (aliases + git abbrs), `config.fish` (sets `SHELL`/`EDITOR`; the `fish_transient_prompt` line is present but commented out), `functions/` (prompt).
- **dot-bashrc** — self-contained: aliases, `mygpp`, sources machine-local `~/.localrc` if present; `pbcopy`/`pbpaste` aliases use `xclip`.
- **dot-ssh/config** — ssh host aliases (`Host cse`, …); live at `~/.ssh/config`.
- **dot-config/git/** — `config` plus `config-uni` (pulled by `includeIf "gitdir/i:**/uni/**"`, uni credentials). `core.excludesfile` points at `~/.config/git/.global_gitignore`, which is machine-local and **not** tracked here.
- **dot-config/ghostty/** — terminal config; its `command` probes fish at `/opt/homebrew`, `/home/linuxbrew`, `/usr/bin`, then PATH, so it works on both macOS and Linux.
- **dot-editorconfig / dot-clang-format** — formatting defaults stowed to `~/.editorconfig` / `~/.clang-format` (nvim does not create these links itself).
- **Brewfile** — source of truth for installed tools (stow, fish, neovim, ripgrep, fd, fzf).
- **README.md roadmap** — the only remaining TODO is the `dotsync` fish function (git pull, ff-only / abort on merge).

## Fish right prompt (async)

- The right prompt is drawn **manually on line 1 of `fish_prompt.fish`**, which calls `custom_right_prompt`. There is no `fish_right_prompt`; fish only positions a native right prompt on the prompt's *last* line, so this code right-aligns itself with `\r\e[<col>G`. To change the right-side content, edit `custom_right_prompt`.
- The git segment is computed **out-of-band**, because fish's `fish_vcs_prompt` spawns several git subprocesses (~100ms per render). `custom_right_prompt` renders a cached value and calls `__custom_right_prompt_kick`, which launches a background fish running `__custom_right_prompt_async`. That job writes `seq\ncwd\nsegment` to a temp file and sends `SIGUSR1`; `__custom_right_prompt_update` (the `--on-signal USR1` handler) applies it and repaints, ignoring stale `seq`/`cwd`.
- `__custom_right_prompt_async` **must stay in its own `functions/` file** — the background fish autoloads it by name. `kick`/`update` live together in `custom_right_prompt.fish`.
- Keep prompt code portable across macOS and Linux (GNU vs BSD differ): use a `mktemp <dir>/name.XXXXXX` template (not `mktemp -t`), and `(status fish-path)` (not a bare `fish`) to launch the background shell.
- `fish_prompt` short-circuits on `--final-rendering` to emit a bare `$PROMPT_CHAR` prompt (transient prompt). Keep that branch: it's what the transient prompt hooks into — note the enabling `set -g fish_transient_prompt 1` in `config.fish` is currently commented out.
- `~/.config/fish/fish_variables` (universal `set -U` state) is machine-local and deliberately untracked — changes there never belong in this repo.

## Portability (macOS + Linux Mint)

- Target both; prefer portable forms. Known platform-specific items: fish `conf.d/abbrs.fish` `pp`/`pi` use `pbpaste` (macOS — Linux would need `xclip`/`wl-paste`), while `dot-bashrc` `pbcopy`/`pbpaste` use `xclip` (Linux).
