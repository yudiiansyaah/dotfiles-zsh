#!/usr/bin/env bash
  set -euo pipefail

  log() {
    printf '\033[1;32m[setup]\033[0m %s\n' "$1"
  }

  need_cmd() {
    command -v "$1" >/dev/null 2>&1
  }

  detect_pkg_manager() {
    if need_cmd apt; then
      echo apt
    elif need_cmd dnf; then
      echo dnf
    elif need_cmd pacman; then
      echo pacman
    elif need_cmd zypper; then
      echo zypper
    else
      echo unknown
    fi
  }

  install_packages() {
    local pm
    pm="$(detect_pkg_manager)"

    case "$pm" in
      apt)
        sudo apt update
        sudo apt install -y zsh git curl unzip wget fontconfig fastfetch fzf
        ;;
      dnf)
        sudo dnf install -y zsh git curl unzip wget fontconfig fastfetch fzf
        ;;
      pacman)
        sudo pacman -Sy --noconfirm zsh git curl unzip wget fontconfig fastfetch fzf
        ;;
      zypper)
        sudo zypper install -y zsh git curl unzip wget fontconfig fastfetch fzf
        ;;
      *)
        echo "Unsupported package manager"
        exit 1
        ;;
    esac
  }

  install_starship() {
    if need_cmd starship; then
      log "starship already installed"
      return
    fi
    curl -fsSL https://starship.rs/install.sh | sh -s -- -y
  }

  clone_or_update_repo() {
    local repo_url="$1"
    local dest_dir="$2"

    if [ -d "$dest_dir/.git" ]; then
      git -C "$dest_dir" pull --ff-only
    else
      git clone "$repo_url" "$dest_dir"
    fi
  }

  install_nerd_font() {
    local font_name="JetBrainsMono"
    local version="3.2.1"
    local zip_name="${font_name}.zip"
    local url="https://github.com/ryanoasis/nerd-fonts/releases/download/v${version}/
  ${zip_name}"
    local tmp_dir

    tmp_dir="$(mktemp -d)"
    mkdir -p "$HOME/.local/share/fonts/NerdFonts"

    if find "$HOME/.local/share/fonts" -iname "*JetBrainsMono*Nerd*Font*.ttf" | grep -q .;
  then
      log "JetBrainsMono Nerd Font already installed"
      rm -rf "$tmp_dir"
      return
    fi

    wget -qO "$tmp_dir/$zip_name" "$url"
    unzip -o "$tmp_dir/$zip_name" -d "$tmp_dir/fonts" >/dev/null
    find "$tmp_dir/fonts" \( -iname "*.ttf" -o -iname "*.otf" \) -exec cp {} "$HOME/.local/
  share/fonts/NerdFonts/" \;
    fc-cache -fv >/dev/null
    rm -rf "$tmp_dir"
  }

  write_starship_config() {
    mkdir -p "$HOME/.config"

    cat > "$HOME/.config/starship.toml" <<'STARSHIP'
  "$schema" = 'https://starship.rs/config-schema.json'

  format = """
  [](red)\
  $os\
  $username\
  [](bg:peach fg:red)\
  $directory\
  [](bg:yellow fg:peach)\
  $git_branch\
  $git_status\
  [](fg:yellow bg:green)\
  $c\
  $rust\
  $golang\
  $nodejs\
  $php\
  $java\
  $kotlin\
  $haskell\
  $python\
  [](fg:green bg:sapphire)\
  $conda\
  [](fg:sapphire bg:lavender)\
  $time\
  [ ](fg:lavender)\
  $cmd_duration\
  $line_break\
  $character"""

  palette = 'catppuccin_mocha'

  [os]
  disabled = false
  style = "bg:red fg:crust"

  [os.symbols]
  Ubuntu = "󰕈"
  Arch = "󰣇"
  Debian = "󰣚"
  Fedora = "󰣛"
  Linux = "󰌽"
  Macos = "󰀵"
  Windows = ""

  [username]
  show_always = true
  style_user = "bg:red fg:crust"
  style_root = "bg:red fg:crust"
  format = '[ $user]($style)'

  [directory]
  style = "bg:peach fg:crust"
  format = "[ $path ]($style)"
  truncation_length = 3
  truncation_symbol = "…/"

  [directory.substitutions]
  "Documents" = "󰈙 "
  "Downloads" = " "
  "Music" = "󰝚 "
  "Pictures" = " "
  "Developer" = "󰲋 "

  [git_branch]
  symbol = ""
  style = "bg:yellow"
  format = '[[ $symbol $branch ](fg:crust bg:yellow)]($style)'

  [git_status]
  style = "bg:yellow"
  format = '[[($all_status$ahead_behind )](fg:crust bg:yellow)]($style) '

  [nodejs]
  symbol = ""
  style = "bg:green"
  format = '[[ $symbol( $version) ](fg:crust bg:green)]($style)'

  [c]
  symbol = " "
  style = "bg:green"
  format = '[[ $symbol( $version) ](fg:crust bg:green)]($style)'

  [rust]
  symbol = ""
  style = "bg:green"
  format = '[[ $symbol( $version) ](fg:crust bg:green)]($style)'

  [golang]
  symbol = ""
  style = "bg:green"
  format = '[[ $symbol( $version) ](fg:crust bg:green)]($style)'

  [php]
  symbol = ""
  style = "bg:green"
  format = '[[ $symbol( $version) ](fg:crust bg:green)]($style)'

  [java]
  symbol = " "
  style = "bg:green"
  format = '[[ $symbol( $version) ](fg:crust bg:green)]($style)'

  [kotlin]
  symbol = ""
  style = "bg:green"
  format = '[[ $symbol( $version) ](fg:crust bg:green)]($style)'

  [haskell]
  symbol = ""
  style = "bg:green"
  format = '[[ $symbol( $version) ](fg:crust bg:green)]($style)'

  [python]
  symbol = ""
  style = "bg:green"
  format = '[[ $symbol( $version)(\(#$virtualenv\)) ](fg:crust bg:green)]($style)'

  [conda]
  symbol = "  "
  style = "fg:crust bg:sapphire"
  format = '[$symbol$environment ]($style)'
  ignore_base = false

  [time]
  disabled = false
  time_format = "%R"
  style = "bg:lavender"
  format = '[[  $time ](fg:crust bg:lavender)]($style)'

  [line_break]
  disabled = true

  [character]
  disabled = false
  success_symbol = '[❯](bold fg:green)'
  error_symbol = '[❯](bold fg:red)'
  vimcmd_symbol = '[❮](bold fg:green)'
  vimcmd_replace_one_symbol = '[❮](bold fg:lavender)'
  vimcmd_replace_symbol = '[❮](bold fg:lavender)'
  vimcmd_visual_symbol = '[❮](bold fg:yellow)'

  [cmd_duration]
  show_milliseconds = true
  format = " in $duration "
  style = "bg:lavender"
  disabled = false
  show_notifications = true
  min_time_to_notify = 45000

  [palettes.catppuccin_mocha]
  red = "#f38ba8"
  peach = "#fab387"
  yellow = "#f9e2af"
  green = "#a6e3a1"
  sapphire = "#74c7ec"
  lavender = "#b4befe"
  crust = "#11111b"
  STARSHIP
  }

  write_zshrc() {
    cat > "$HOME/.zshrc" <<'ZSHRC'
  HISTFILE="$HOME/.zsh_history"
  HISTSIZE=10000
  SAVEHIST=10000

  setopt AUTO_CD
  setopt APPEND_HISTORY
  setopt SHARE_HISTORY
  setopt HIST_IGNORE_DUPS
  setopt HIST_IGNORE_ALL_DUPS
  setopt HIST_FIND_NO_DUPS
  setopt HIST_REDUCE_BLANKS
  setopt INTERACTIVE_COMMENTS
  setopt NO_BEEP

  typeset -U path PATH fpath
  path=("$HOME/.local/bin" "$HOME/bin" $path)
  export PATH

  autoload -Uz colors compinit
  colors

  ZSH_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
  mkdir -p "$ZSH_CACHE_DIR"

  if [[ -d "$HOME/.zsh/plugins/zsh-completions/src" ]]; then
    fpath+=("$HOME/.zsh/plugins/zsh-completions/src")
  fi

  compinit -d "$ZSH_CACHE_DIR/.zcompdump"

  zstyle ':completion:*' menu select
  zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

  alias reload='source ~/.zshrc'
  alias cls='clear'
  alias grep='grep --color=auto'
  alias ls='ls --color=auto'
  alias ll='ls -lah'
  alias la='ls -A'

  if [[ -f "$HOME/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
    source "$HOME/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'
  fi

  if [[ -f "$HOME/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]];
  then
    source "$HOME/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
  fi

  bindkey '^[[A' history-search-backward
  bindkey '^[[B' history-search-forward

  eval "$(starship init zsh)"

  [[ -o interactive ]] && command -v fastfetch >/dev/null 2>&1 && fastfetch
  ZSHRC
  }

  apply_terminal_fonts() {
    local font="JetBrainsMono Nerd Font 11"

    if need_cmd gsettings; then
      gsettings set org.gnome.desktop.interface monospace-font-name "$font" || true
      gsettings set org.gnome.Terminal.Legacy.Settings default-show-menubar false || true
    fi

    if [ -d "$HOME/.config/kitty" ]; then
      mkdir -p "$HOME/.config/kitty"
      grep -q '^font_family ' "$HOME/.config/kitty/kitty.conf" 2>/dev/null \
        && sed -i 's/^font_family .*/font_family JetBrainsMono Nerd Font/' "$HOME/.config/
  kitty/kitty.conf" \
        || printf '\nfont_family JetBrainsMono Nerd Font\nfont_size 11.0\n' >>
  "$HOME/.config/kitty/kitty.conf"
    fi

    if [ -f "$HOME/.config/alacritty/alacritty.toml" ]; then
      mkdir -p "$HOME/.config/alacritty"
      cat > "$HOME/.config/alacritty/alacritty.toml" <<'ALACRITTY'
  [font]
  size = 11.0

  [font.normal]
  family = "JetBrainsMono Nerd Font"
  style = "Regular"
  ALACRITTY
    fi

    if [ -f "$HOME/.wezterm.lua" ] || [ -d "$HOME/.config/wezterm" ]; then
      mkdir -p "$HOME/.config/wezterm"
      cat > "$HOME/.config/wezterm/wezterm.lua" <<'WEZTERM'
  local wezterm = require 'wezterm'
  return {
    font = wezterm.font("JetBrainsMono Nerd Font"),
    font_size = 11.0,
  }
  WEZTERM
    fi

    if [ -d "$HOME/.config/konsole" ]; then
      mkdir -p "$HOME/.local/share/konsole" "$HOME/.config"
      cat > "$HOME/.local/share/konsole/JetBrainsMonoNerd.profile" <<'KONSOLE'
  [Appearance]
  ColorScheme=Breeze

  [General]
  Name=JetBrainsMono Nerd

  [Font]
  Font=JetBrainsMono Nerd Font,11,-1,5,50,0,0,0,0,0
  KONSOLE
      grep -q 'DefaultProfile=' "$HOME/.config/konsolerc" 2>/dev/null \
        && sed -i 's/^DefaultProfile=.*/DefaultProfile=JetBrainsMonoNerd.profile/'
  "$HOME/.config/konsolerc" \
        || printf '[Desktop Entry]\nDefaultProfile=JetBrainsMonoNerd.profile\n' >
  "$HOME/.config/konsolerc"
    fi

    if need_cmd dconf; then
      local profile
      profile="$(gsettings get org.gnome.Terminal.ProfilesList default 2>/dev/null | tr -d
  \')"
      if [ -n "${profile:-}" ]; then
        dconf write "/org/gnome/terminal/legacy/profiles:/:$profile/use-system-font"
  "false" || true
        dconf write "/org/gnome/terminal/legacy/profiles:/:$profile/font" "'JetBrainsMono
  Nerd Font 11'" || true
      fi
    fi
  }

  set_default_shell() {
    local zsh_path
    zsh_path="$(command -v zsh)"
    if [ "${SHELL:-}" != "$zsh_path" ]; then
      chsh -s "$zsh_path"
    fi
  }

  main() {
    install_packages
    install_starship
    install_nerd_font

    mkdir -p "$HOME/.zsh/plugins"

    clone_or_update_repo "https://github.com/zsh-users/zsh-autosuggestions.git" "$HOME/.zs
  h/plugins/zsh-autosuggestions"
    clone_or_update_repo "https://github.com/zsh-users/zsh-syntax-highlighting.git" "$HOME
  /.zsh/plugins/zsh-syntax-highlighting"
    clone_or_update_repo "https://github.com/zsh-users/zsh-completions.git" "$HOME/.zsh/pl
  ugins/zsh-completions"

    write_starship_config
    write_zshrc
    apply_terminal_fonts
    set_default_shell

    log "Done"
    log "If one terminal still ignores the font, reopen the app fully first."
    log "Run: exec zsh"
  }

  main "$@"

