# Emacs

This is a serious Doom Emacs experiment, not a Neovim replacement plan.

## Shape

- Nix installs Emacs and the support tools.
- Doom's live config lives in [config/doom](../../config/doom).
- Home Manager links `~/.config/doom` and `~/.doom.d` to the repo config so
  editing `init.el`, `config.el`, or Org notes does not require a rebuild.
- Doom itself is cloned from upstream with `doom-bootstrap`, into
  `~/.config/emacs`.

## Installed By Nix

- `emacs-pgtk` from the flake's Nixpkgs pin.
- Core project tools: Git, ripgrep, fd, EditorConfig, tree-sitter.
- Rich document support: sqlite, gnutls, ImageMagick, zstd, unzip, pandoc,
  TeX Live Small, aspell English, and Harper.
- vterm native support: libvterm, cmake, gnumake, gcc, pkg-config.
- Nix editing support: nil and nixfmt.
- Lua, QML/Qt, Rust, C, and C++ LSP support: lua-language-server,
  qt6.qtlanguageserver, rust-analyzer, and clang-tools.

## Doom Modules

- Evil mode for Vim muscle memory.
- Org mode for notes and project planning.
- Magit for Git.
- Dired for file management.
- vterm for the embedded terminal.
- Vertico/company, LSP, snippets, syntax/spell checking, Markdown, Nix, shell,
  Lua, QML/Qt, Rust, C/C++, JSON, YAML, and Emacs Lisp.
- Harper runs through LSP for Org, Markdown, and plain text diagnostics while
  writing.

## Commands

After rebuilding once:

```sh
doom-bootstrap
```

Then use:

```sh
doom sync
emacs
```

Run `doom sync` after changing `config/doom/init.el` or
`config/doom/packages.el`. Most edits to `config.el` and Org files are live
after restarting or reloading Emacs.
