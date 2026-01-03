#!/bin/bash
set +e
set -euo pipefail

# ==============================
# CONFIG
# ==============================
WORKDIR="$HOME/InstallingDot"
FONTDIR="$HOME/.local/share/fonts"
WALLDIR="$HOME/Wallpaper"

PACKAGES=(
  git zsh imagemagick dunst unzip zip python3 python-pip
  feh kitty maim picom rofi bluez polybar thunar xclip
  noto-fonts-emoji materia-gtk-theme
)

git clone https://aur.archlinux.org/neofetch.git
cd neofetch
makepkg -si --skippgpcheck

# ==============================
# FUNCTIONS
# ==============================
msg() { echo -e "\n▶ $1\n"; }
pause() { sleep 2; }

install_packages() {
  msg "Installing dependencies..."

  if command -v pacman >/dev/null; then
    sudo pacman -Sy --noconfirm "${PACKAGES[@]}"
  elif command -v apt >/dev/null; then
    sudo apt update
    sudo apt install -y "${PACKAGES[@]}"
  else
    echo "❌ Unsupported package manager"
    exit 1
  fi
}

# ==============================
# START
# ==============================
clear
install_packages
pause

# ==============================
# PYWAL
# ==============================
msg "Installing pywal16"
sudo pip install pywal16 --break-system-packages

# ==============================
# DIRECTORIES
# ==============================
mkdir -p "$WORKDIR" "$FONTDIR" "$WALLDIR"
cd "$WORKDIR"

# ==============================
# FONTS
# ==============================
msg "Installing fonts"

wget -q https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/JetBrainsMono.zip
wget -q https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/Iosevka.zip

unzip -oq JetBrainsMono.zip -d "$FONTDIR/JetBrainsMono"
unzip -oq Iosevka.zip -d "$FONTDIR/Iosevka"

if [ ! -d "$FONTDIR/GoogleSans/.git" ]; then
    git clone https://github.com/hprobotic/Google-Sans-Font.git "$FONTDIR/GoogleSans"
else
    git -C "$FONTDIR/GoogleSans" pull
fi


mkdir -p "$FONTDIR/Material-icons"
wget -q -O "$FONTDIR/Material-icons/MaterialSymbols.ttf" \
https://raw.githubusercontent.com/google/material-design-icons/master/variablefont/MaterialSymbolsOutlined%5BFILL%2CGRAD%2Copsz%2Cwght%5D.ttf

fc-cache -fv
pause

# ==============================
# DOTFILES
# ==============================
msg "Installing dotfiles"
if [ -d "$WORKDIR/MaterialBox/.git" ]; then
    echo "Dotfile is already installed, updating to latest"
    git -C "$WORKDIR/MaterialBox" pull --ff-only
else
    echo "Updating MaterialBox"
    git clone https://github.com/GoofyOzy4/MaterialBox "$WORKDIR/MaterialBox"
fi

cp -r "$WORKDIR/MaterialBox/.config" ~/
cp -r "$WORKDIR/MaterialBox/.local/share/"* ~/.local/share/
cp -r "$WORKDIR/MaterialBox/.themes" ~/
cp -r "$WORKDIR/MaterialBox/.gtkrc-2.0" ~/

# ==============================
# WALLPAPER + PYWAL
# ==============================
msg "Setting wallpaper and colors"

cp "$WORKDIR/MaterialBox/Wallpaper/Wallpaper.png" "$WALLDIR/"

ln -sf ~/.cache/wal/dunstrc ~/.config/dunst/dunstrc
ln -sf ~/.cache/wal/themerc ~/.themes/Material3/openbox-3/themerc
sleep 0.3
wal -i "$WALLDIR/Wallpaper.png"

dunst &
sleep 5
notify-send "Test" "Dunst is working!" -i "$WALLDIR/Wallpaper.png"

# ==============================
# PERMISSIONS
# ==============================
chmod +x ~/.config/polybar/scripts/{network.sh,powermenu.sh,volume.sh,wallpaper.sh}

# ==============================
# ZSH
# ==============================
msg "Installing Oh My Zsh"

if [ ! -d "$HOME/.oh-my-zsh" ]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

chsh -s "$(which zsh)"

sleep 2

cp "$WORKDIR/MaterialBox/.oh-my-zsh/themes/minimal.zsh-theme" ~/.oh-my-zsh/themes/
cp "$WORKDIR/MaterialBox/.zshrc" ~/

# ==============================
# CLEANUP
# ==============================
rm -rf "$WORKDIR"
set -e

msg "✅ Installation complete!"
