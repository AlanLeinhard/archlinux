#!/bin/bash

echo 'Раскомментируем репозиторий multilib Для работы 32-битных приложений в 64-битной системе.'
echo '[multilib]' >> /etc/pacman.conf
echo 'Include = /etc/pacman.d/mirrorlist' >> /etc/pacman.conf
pacman -Syyu --noconfirm


gui_install="xorg xorg-server gnome gnome-extra gdm nvidia nvidia-utils lib32-nvidia-utils nvidia-settings vulkan-icd-loader lib32-vulkan-icd-loader lib32-opencl-nvidia opencl-nvidia xorg-server-devel libxnvctrl xf86-video xf86-video-amdgpu mesa lib32-mesa"

echo 'Ставим иксы и драйвера'
pacman -S $gui_install --noconfirm


echo 'Cтавим DM'
systemctl enable gdm
 
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

cd yay/ && makepkg -si && cd ..

yay -S firefox-bin telegram-desktop-bin onlyoffice-bin visual-studio-code-bin ttf-times-new-roman yandex-music-player discord-rpc-bin ventoy-bin anilibria-winmaclinux proton-ge-custom-bin gputest gnome-browser-connector timeshift --noconfirm

sudo pacman -S docker lshw blkid wmctrl steam discord audacity krita kdenlive obs-studio mpg123 mpv dosfstools gamin ntfs-3g wine base-devel git gvfs ccache grub-customizer neofetch --noconfirm

echo 'WaylandEnable=false' >> sudo vim /etc/gdm/custom.conf

sudo mkinitcpio -P
sudo X -configure
sudo cp /etc/X11/xorg.conf.backup /etc/X11/xorg.conf

sudo gpasswd -a alan docker
sudo systemctl enable docker
sudo systemctl start docker

sudo docker pull postgres
sudo docker pull dpage/pgadmin4

sudo docker run -p 80:80 \
    -e 'PGADMIN_DEFAULT_EMAIL=user@domain.com' \
    -e 'PGADMIN_DEFAULT_PASSWORD=SuperSecret' \
    -d dpage/pgadmin4

sudo docker run --name some-postgres -e POSTGRES_PASSWORD=mysecretpassword -d postgres