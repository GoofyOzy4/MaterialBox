#!/bin/sh
# By Goofy_Ozy4
# # # # # # # # # # Install Dependencies # # # # # # # # # # #
# Dependencies
clear
sleep 3
PACKAGES="git zsh imagemagick dunst unzip zip python3 python-pip feh kitty maim picom rofi bluez polybar thunar xclip feh noto-fonts-emoji"

# Detect your package manager
echo "📦 Installing dependencies..."
elif command -v pacman >/dev/null; then
    sudo pacman -Sy $PACKAGES --noconfirm
else
    echo "Error: Unsupported package manager. Try edit the installation script"
    sleep 10
    exit
fi

sleep 5
# # # # # # # # # # Install pywal # # # # # # # # # #
clear
echo "📁 Setting up color pallete generator (pywal16)..."
sudo pip install "pywal16" --break-system-packages

mkdir ~/InstallingDot
cd ~/InstallingDot
sleep 5

# # # # # # # # # # Install fonts # # # # # # # # # #
clear
echo "📁 Setting up fonts..."
mkdir -p ~/.local/share/fonts
clear

echo "📁 Setting up fonts..."
echo "• Downloading JetBrainsMono font..."
wget -q https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/JetBrainsMono.zip
clear

echo "📁 Setting up fonts..."
echo "• Google Sans font..."
git clone https://github.com/hprobotic/Google-Sans-Font.git ~/.local/share/fonts
clear

echo "📁 Setting up fonts..."
echo "• Material symbols font..."
wget --no-hsts -cNP ~/.local/share/fonts/Material-icons/ \
https://raw.githubusercontent.com/google/material-design-icons/master/variablefont/MaterialSymbolsOutlined%5BFILL%2CGRAD%2Copsz%2Cwght%5D.ttf
clear

echo "📁 Setting up fonts..."
echo "• Downloading Iosevka font..."
wget -q https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/Iosevka.zip
clear

echo "📁 Unpacking fonts..."
unzip -q JetBrainsMono.zip -d ~/.local/share/fonts/JetBrainsMono
unzip -q Iosevka.zip -d ~/.local/share/fonts/Iosevka

cd ~/InstallingDot
clear

echo "📁 Generating cache for fonts..."
sleep 3
kitty fc-cache -fv
echo "done !"
sleep 3
# # # # # # # # # Install Dotfiles # # # # # # # # # #
clear
echo "📂 Installing dotfiles..."
git clone https://github.com/GoofyOzy4/MaterialBox ~/InstallingDot/MaterialBox
cp -r ~/InstallingDot/MaterialBox/.config ~/
sleep 1
cp -r ~/InstallingDot/MaterialBox/.local/share/* ~/.local/share/
sleep 1
# # # # # # # # # Install wallpaper # # # # # # # # # #
echo "🖼️ Setting up wallpapers..."
mkdir -p ~/Wallpaper

# Download wallpapers
cp -r ~/InstallingDot/MaterialBox/Wallpaper/Wallpaper.png ~/Wallpaper/

echo "🖼️ Auto-generating color pallete from wallpaper and check dunst..."
kitty wal -i ~/Wallpaper/Wallpaper.png
kitty ln -sf ~/.cache/wal/dunstrc ~/.config/dunst/dunstrc
dunst &
sleep 2
notify-send "Test" "If you see this message - dunst work!" -i ~/Wallpaper/Wallpaper.png
sleep 3
notify-send "Test" "Write sudo pass." -i ~/Wallpaper/Wallpaper.png

# Set some permissions
chmod +x ~/.config/polybar/scripts/network.sh
chmod +x ~/.config/polybar/scripts/powermenu.sh
chmod +x ~/.config/polybar/scripts/volume.sh
chmod +x ~/.config/polybar/scripts/wallpaper.sh

# # # # # # # # # # Install zsh # # # # # # # # # #
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
kitty chsh -s $(which zsh)
cp -r ~/InstallingDot/MaterialBox/.oh-my-zsh/themes/minimal.zsh-theme ~/.oh-my-zsh/themes/minimal.zsh-theme
cp -r ~/InstallingDot/MaterialBox/.zshrc ~/
clear
sleep 0.3
rm -rf ~/InstallingDot
notify-send "app" "Done !"
# # # # # # # # # Clear all # # # # # # # # # #
clear
echo "✅ Installation complete!"
sleep 10
exit 0
