# Murat's Dotfiles

A minimalist, high-performance Zsh configuration optimized for modern development and container-heavy workflows. 

Forked originally from [geerlingguy's dotfiles](https://github.com/geerlingguy/dotfiles), this repository has been heavily customized to respect the default power of macOS/Linux terminals while adding true color precision and zero-lag utilities for Go, Node.js, Python, and Docker.

![Terminal Screenshot](https://github.com/ecoderat/dotfiles/raw/assets/terminal.png)


## 🚀 Key Features

* **True Color (24-bit RGB) Prompt:** A blazing fast, lag-free prompt that auto-detects and displays active `go`, `node`, and `python` (including `pyenv`) versions using pixel-perfect RGB colors.
* **Throwaway Databases:** Instant, auto-destructing Docker containers for rapid testing. Commands like `run-redis`, `run-postgres`, and `run-clickhouse` spin up temporary instances that clean up after themselves the moment they are stopped. 
* **Beautiful Git Logs:** A highly customized `git lg` alias that renders a clean, hierarchical commit graph using precise ANSI RGB color codes to prevent theme bleeding.
* **Smart Navigation & Safety:** Universal lifesavers like `mkcd` (make and enter directory instantly), and safe defaults for destructive commands (`rm`, `cp`, `mv`).
* **Zero Bloat:** No heavy frameworks (like Oh-My-Zsh). Just raw, optimized Zsh scripting that loads instantly.

## 🛠 Usage

This configuration is primarily built for macOS using Zsh as the default shell, but the aliases and functions are highly universal and will feel right at home on most Linux environments.

To apply the configuration, simply copy the `.zshrc` and `.gitconfig` files to your home directory, or symlink them:

```bash
ln -s ~/dotfiles/.zshrc ~/.zshrc
ln -s ~/dotfiles/.gitconfig ~/.gitconfig
source ~/.zshrc

```

## 📜 Credits & License

* **Author:** Murat
* **Original Architecture:** Jeff Geerling (@geerlingguy)
* **Inspired By:** [vigo/dotfiles-light](https://github.com/vigo/dotfiles-light) for the minimalist, performance-first Linux philosophy.

MIT / BSD
