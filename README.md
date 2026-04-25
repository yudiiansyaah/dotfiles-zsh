# Zsh Bootstrap

  A one-shot bootstrap script for Linux that sets up a complete terminal environment with:

  - Zsh
  - Starship prompt
  - `zsh-autosuggestions`
  - `zsh-syntax-highlighting`
  - `zsh-completions`
  - JetBrainsMono Nerd Font
  - A ready-to-use `.zshrc`
  - Automatic terminal font setup where possible

  ## Supported package managers

  This script currently supports:

  - `apt`
  - `dnf`
  - `pacman`
  - `zypper`

  ## What this script does

  The script will:

  1. Install required packages
  2. Install Starship
  3. Install Zsh plugins
  4. Install JetBrainsMono Nerd Font
  5. Generate a fresh `~/.zshrc`
  6. Generate `~/.config/starship.toml`
  7. Try to apply Nerd Font settings to supported terminal emulators
  8. Set Zsh as the default shell

  ## Installation

  Clone the repository:

  ```bash
  git clone https://github.com/yudiiansyaah/dotfiles-zsh.git
  cd dotfiles-zsh

  Run the bootstrap script:

  chmod +x setup/bootstrap-zsh-full.sh
  ./setup/bootstrap-zsh-full.sh

  Reload your shell:

  exec zsh

  ## Notes

  - The script is safe to run more than once.
  - Your existing ~/.zshrc will be backed up automatically before being replaced.
  - If icons still look broken, manually set your terminal font to:

  JetBrainsMono Nerd Font

  ## Terminals with automatic font configuration

  The script attempts to apply font settings for:

  - GNOME Terminal
  - Konsole
  - Kitty
  - Alacritty
  - WezTerm

  Some terminals may still require a full restart before the font change appears.

  ## Repository structure

  dotfiles-zsh/
  ├── README.md
  └── setup/
      └── bootstrap-zsh-full.sh

  ## License

  Feel free to use, modify, and share this project.
