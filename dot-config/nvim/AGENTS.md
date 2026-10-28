# AGENTS.md

Personal Neovim config, user is `tamizrj`. Leader key is `<space>`. Targets Neovim 0.12+ (built-in `vim.pack`; verified against 0.12.5).

## Layout

- **Monolithic config**: everything lives in a single `lua`/`vim` script at the repo root, `init.lua`. There is no modular `lua/plugins/` structure. Add new config inline in its logical section (mini modules, LSP, keymaps, etc.).
- `nvim-pack-lock.json` — lockfile managed by `vim.pack` (see "Plugin management").
- `snippets/` — **not referenced in `init.lua`**: blink.cmp's default snippets source auto-discovers `stdpath('config') .. '/snippets'`. The VSCode-style `package.json` manifest registers `cpp.json` for the cpp filetype.
- `tests/` — scratch files used to validate formatting/LSP behavior; not a test framework.
- `.editorconfig` / `.clang-format` are stow-managed by the parent dotfiles repo (`dot-editorconfig` / `dot-clang-format` at the dotfiles root → `~/.editorconfig`, `~/.clang-format`). **nvim does not symlink them** — the README's "symlinked on startup" is stale. `~/.editorconfig` overrides init.lua's 4-space default to 2 spaces for Lua.

## Plugin management

- Plugins are declared with `vim.pack.add({ gh '<owner/repo>', ... })` — **not** lazy.nvim or packer. Add new plugins there.
- Custom commands defined near the top of `init.lua`:
  - `:PackUpdate` — `vim.pack.update()`: fetch, propose updates, then check out confirmed revisions and write them to the lockfile. **It opens a confirmation buffer** — nothing is applied (and the lockfile isn't written) until you confirm there.
  - `:PackSync` — `update(nil, { target = 'lockfile' })`: force **local installs to match the lockfile** (the "after pulling it on another machine" direction). It does not update the lockfile — don't confuse it with `:PackUpdate`.
  - `:PackClean` — delete plugins no longer active in the specs; `:PackDelete <name>` — delete one package from disk and lockfile.
- After editing `vim.pack.add` specs, restart nvim, then `:PackUpdate` / `:PackClean` so `nvim-pack-lock.json` stays in sync. Never hand-edit the lockfile; don't commit changes to it that weren't produced by the commands.
- `mini.nvim` is the primary framework (one monorepo). Before using a `Mini*` API, check the installed version's docs/source in
  `~/.local/share/nvim/site/pack/core/opt/mini.nvim/lua/mini/<name>.lua` — behavior differs across versions.
- Treesitter uses the **main**-branch API of `nvim-treesitter` (`require('nvim-treesitter').setup(...)` directly; highlighting started from a `FileType` autocmd). Ignore the ubiquitous `require('nvim-treesitter.configs').setup` examples — that's the frozen master branch.

## Conventions

- Lua style: 2-space indent, single quotes. Do not add code comments unless the config uses them nearby.
- Keymap `desc` strings use a mnemonic pattern: `'[p]ick [f]iles'`, `'[g]o to [d]efinition'`, `'[r]e[n]ame symbol'` — the bracketed letter(s) are the actual keys.
- Pickers from `mini.extra` live under the `<leader>p` group (`<leader>pf` files, `pb` buffers, `pg` grep, `pH` hipatterns, git/neovim pickers…). `mini.clue` shows the group via its triggers.
- LSP keymaps are buffer-local, created inside the `LspAttach` autocmd (`UserLspConfig` augroup). Navigation uses the `g` prefix: `grd`, `grD`, `grr`, `gri`, `grT`, `K`, `grn`, `gra`. Symbol pickers are `<leader>psd` / `<leader>psw`.
- Location-based LSP pickers go through `extra_lsp_or_jump(scope)` (defined before the `LspAttach` autocmd): exactly one result jumps directly; multiple open the `mini.extra` picker.
- Format-on-save is **off** (`local formatOnSave = false` in `init.lua`) despite the README listing it as a feature — formatting is manual via `<leader>f` (conform, `lsp_format = 'fallback'`). Toggling that flag is a user decision.

## Verification

- Fast syntax check (does not load plugins; prints `OK` on success):
  ```sh
  nvim --clean --headless "+lua local f, err = loadfile('<abs path>/init.lua'); if not f then print('SYNTAX ERROR: ' .. tostring(err)) vim.cmd('cq') else print('OK') end" +qa
  ```
  Note: When running from a Neovim `:terminal`, `$NVIM` is exported in the environment. Prefix with `env -u NVIM` (e.g. `env -u NVIM nvim --clean --headless ...`) so `flatten.nvim` does not intercept the process or forward commands like `+qa` to the host Neovim instance.
- Syntax-only checks are insufficient for behavior. After non-trivial changes, exercise the affected path in a headless nvim (use `env -u NVIM nvim --headless ...` if inside a terminal; e.g. stub `vim.lsp.buf[scope]` to call `opts.on_list` and assert the direct-jump vs picker branches), or source the full config with plugins present.
- Plugin state is in the standard `~/.local/share/nvim/` data dir (`site/pack/core/opt` for plugins, `mason` for LSP tooling).
