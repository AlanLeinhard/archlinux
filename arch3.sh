#!/bin/bash

echo 'Раскомментируем репозиторий multilib Для работы 32-битных приложений в 64-битной системе.'
echo '[multilib]' >> /etc/pacman.conf
echo 'Include = /etc/pacman.d/mirrorlist' >> /etc/pacman.conf
pacman -Syyu --noconfirm

            # gnome gdm\
            # plasma sddm konsole dolphin ark kwrite kcalc spectacle krunner partitionmanager packagekit-qt5\

gui_install="xorg xorg-server xorg-server-devel\
            awesome\
            nvidia-dkms nvidia-utils lib32-nvidia-utils nvidia-settings vulkan-icd-loader lib32-vulkan-icd-loader lib32-opencl-nvidia opencl-nvidia libxnvctrl\ 
            xf86-video xf86-video-amdgpu mesa lib32-mesa"

echo 'Ставим иксы и драйвера'
pacman -S $gui_install --noconfirm


echo 'Cтавим DM'
# systemctl enable gdm
# systemctl enable sddm

echo 'exec awesome' > ~/.xinitrc

echp 'Ставим AUR'
sudo pacman -S --needed base-devel git --noconfirm

mkdir Downloads
mkdir Downloads/aur
cd Downloads/aur/

git clone https://aur.archlinux.org/yay.git

cd yay/ && makepkg -si && cd ..

sudo pacman -S telegram-desktop protontricks firefox docker lshw blkid wmctrl steam discord audacity krita kdenlive obs-studio mpg123 mpv dosfstools gamin ntfs-3g wine base-devel git gvfs ccache grub-customizer neofetch portproton --noconfirm

yay -S onlyoffice-bin visual-studio-code-bin ttf-times-new-roman yandex-music-player ventoy-bin anilibria-winmaclinux proton-ge-custom-bin gputest gnome-browser-connector timeshift --noconfirm

echo 'WaylandEnable=false' >> sudo vim /etc/gdm/custom.conf

sudo mkinitcpio -P
sudo X -configure
sudo cp /etc/X11/xorg.conf.backup /etc/X11/xorg.conf

sudo groupadd docker
sudo usermod -aG docker $USER

sudo systemctl enable docker
sudo systemctl start docker

sudo docker pull postgres
sudo docker pull dpage/pgadmin4

sudo docker run -p 80:80 \
    -e 'PGADMIN_DEFAULT_EMAIL=user@domain.com' \
    -e 'PGADMIN_DEFAULT_PASSWORD=SuperSecret' \
    -d dpage/pgadmin4

sudo docker run --name some-postgres -e POSTGRES_PASSWORD=mysecretpassword -d postgres