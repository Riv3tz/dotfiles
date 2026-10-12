# Catppuccin dotfiles

Linux terminal and VS Code setup with Catppuccin Mocha, JetBrains Mono Nerd Font, and an Agnoster powerline prompt on one line.

The prompt shows the current directory, Git branch and working-tree state, failed-command status, background jobs and command duration after two seconds. Oh My Zsh supplies completion and Git helpers; autosuggestions and syntax highlighting use the same palette.

## Ghostty shortcuts

| Keys | Action |
| --- | --- |
| Ctrl+T | New tab |
| Ctrl+Tab | Next tab |
| Ctrl+Shift+Tab | Previous tab |
| Ctrl+Enter | Available to shell applications |

Ghostty uses the laptop configuration: Catppuccin Mocha, 11pt JetBrains Mono Nerd Font and Zsh. VS Code uses Zsh, JetBrains Mono Nerd Font Mono and the Catppuccin Mocha editor theme; its existing terminal shortcuts are retained.

## Prerequisites

Install Zsh, Git, curl, Python 3, [Ghostty](https://ghostty.org), [JetBrains Mono Nerd Font](https://github.com/ryanoasis/nerd-fonts/releases). Install fonts under `~/.local/share/fonts/` and run `fc-cache -f`.

For Ubuntu:

```sh
sudo apt install zsh git curl python3 fontconfig
```

Install [Oh My Zsh](https://github.com/ohmyzsh/ohmyzsh) and its plugins if absent:

```sh
git clone --depth 1 https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh"
git clone --depth 1 https://github.com/zsh-users/zsh-autosuggestions.git "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions"
git clone --depth 1 https://github.com/zsh-users/zsh-syntax-highlighting.git "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"
```

## Install

```sh
git clone https://github.com/Riv3tz/dotfiles.git
cd dotfiles
./install.sh
```

The installer backs up existing files under `~/.local/state/dotfiles-backups/`, installs the shell and terminal configs, and merges the included VS Code settings while retaining unrelated settings and terminal profiles. It installs the official Catppuccin VS Code extension when `code` is available. For VS Code settings containing comments or trailing commas, merge `vscode/settings.json` manually and convert to valid JSON before using the installer. It does not change the system login shell.

Reload Ghostty's configuration using Ctrl+Shift+, or restart Ghostty. Open a new terminal or run `exec zsh` to activate the prompt. VS Code settings apply to new integrated terminals.

Optional tools already supported in the shell include NVM, pnpm, Rust, OpenCode and LM Studio. Their paths use `$HOME`; absent tools are harmless. Private machine-specific settings can go in `~/.zshrc.local`, which this repository ignores. Existing `~/.profile` is sourced for login shells but is not included here.

## Public repository scope

Only the explicitly listed configuration files, installer and documentation are tracked. Credentials, tokens, private keys, environment files, shell history, caches, local overrides and personal Git identity are excluded. No font binaries or third-party plugin repositories are bundled. Review additions before committing; ignore rules do not replace a secrets review.
