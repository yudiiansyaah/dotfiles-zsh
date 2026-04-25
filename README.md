# Zsh Bootstrap

  Script sekali jalan untuk setup terminal Linux:

  - `zsh`
  - `starship`
  - `zsh-autosuggestions`
  - `zsh-syntax-highlighting`
  - `zsh-completions`
  - `JetBrainsMono Nerd Font`
  - `.zshrc`
  - tema `starship`
  - apply font ke terminal umum kalau memungkinkan

  ## Cara pakai

  ### 1. Clone repo
  ```bash
  git clone https://github.com/yudiiansyaah/dotfiles-zsh.git
  cd dotfiles-zsh

  ### 2. Jalankan script

  chmod +x setup/bootstrap-zsh-full.sh
  ./setup/bootstrap-zsh-full.sh

  ### 3. Reload shell

  exec zsh

  ## Catatan

  - Script akan deteksi package manager: apt, dnf, pacman, atau zypper.
  - Script aman dijalankan ulang.
  - Script akan backup ~/.zshrc lama sebelum replace.
  - Jika icon prompt masih rusak, ubah font terminal ke JetBrainsMono Nerd Font.

  ## Terminal yang dicoba di-apply otomatis

  - GNOME Terminal
  - Konsole
  - Kitty
  - Alacritty
  - WezTerm
