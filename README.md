# Gunsio Homebrew Tap

Homebrew tap for Moonbox prereleases.

```bash
brew tap Gunsio/tap
brew trust --formula gunsio/tap/moonbox
brew install moonbox
```

Moonbox is a cross-CLI session continuation workbench for Codex, Claude, Hermes,
and related AI CLI workflows.

Homebrew 5 requires explicit trust for third-party taps. Trusting only
`gunsio/tap/moonbox` is narrower than trusting the whole tap.

On Apple Silicon macOS, the formula installs Moonbox from the tagged binary
archive and does not require Rust, LLVM, or Apple Command Line Tools for the
default install path.
