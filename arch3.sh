
echo 'Ставим программу для Wi-fi'
pacman -Syyu dhcpcd nmcli --noconfirm
systemctl enable dhcpcd

echo 'Раскомментируем репозиторий multilib Для работы 32-битных приложений в 64-битной системе.'
echo '[multilib]' >> /etc/pacman.conf
echo 'Include = /etc/pacman.d/mirrorlist' >> /etc/pacman.conf
pacman -Syyu --noconfirm


gui_install="xorg xorg-server gnome gnome-extra gdm nvidia nvidia-utils lib32-nvidia-utils nvidia-settings cuda vulkan-icd-loader lib32-vulkan-icd-loader lib32-opencl-nvidia opencl-nvidia libxnvctrl"

echo 'Ставим иксы и драйвера'
pacman -S $gui_install --noconfirm


echo 'Cтавим DM'
systemctl enable gdm

# echo 'Установка базовых программ и пакетов'
# sudo pacman -S reflector firefox firefox-i18n-ru ufw f2fs-tools dosfstools ntfs-3g alsa-lib alsa-utils file-roller p7zip unrar gvfs aspell-ru pulseaudio pavucontrol --noconfirm

# echo "Ставим i3"
# pacman -S i3-gaps polybar dmenu pcmanfm xterm ttf-font-awesome feh gvfs udiskie ristretto tumbler picom jq --noconfirm
    
echo 'Ставим сеть'
pacman -S networkmanager network-manager-applet ppp --noconfirm

echo 'Подключаем автозагрузку менеджера входа и интернет'
systemctl enable NetworkManager

echp 'Ставим AUR'
sudo pacman -S --needed base-devel git --noconfirm

mkdir Downloads
mkdir Downloads/aur
cd Downloads/aur/

git clone https://aur.archlinux.org/yay.git
# git clone https://aur.archlinux.org/firefox-bin.git 
# git clone https://aur.archlinux.org/telegram-desktop-bin.git
# git clone https://aur.archlinux.org/onlyoffice-bin.git
# git clone https://aur.archlinux.org/visual-studio-code-bin.git 
# git clone https://aur.archlinux.org/ttf-times-new-roman.git
# git clone https://aur.archlinux.org/yandex-music-player.git
# git clone https://aur.archlinux.org/discord-rpc-bin.git
# git clone https://aur.archlinux.org/proton-ge-custom-bin.git

cd yay/ && makepkg -si && cd ..
# cd firefox-bin/ && makepkg -si && cd ..
# cd telegram-desktop-bin/ && makepkg -si && cd ..
# cd onlyoffice-bin/ && makepkg -si && cd ..
# cd visual-studio-code-bin/ && makepkg -si && cd ..
# cd ttf-times-new-roman/ && makepkg -si && cd ..
# cd yandex-music-player/ && makepkg -si && cd ..
# cd discord-rpc-bin/ && makepkg -si && cd ..

yay -S firefox-bin telegram-desktop-bin onlyoffice-bin visual-studio-code-bin ttf-times-new-roman yandex-music-player discord-rpc-bin ventoy-bin anilibria-winmaclinux gputest --noconfirm

sudo pacman -S steam discord audacity krita kdenlive obs-studio mpg123 mpv dosfstools gamin ntfs-3g wine base-devel git gvfs ccache grub-customizer neofetch --noconfirm

# cd proton-ge-custom-bin/ && makepkg -si && cd

# yay -S timeshift