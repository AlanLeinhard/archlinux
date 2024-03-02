#!/bin/bash
start_dir=$(pwd)
echo 'Раскомментируем репозиторий multilib Для работы 32-битных приложений в 64-битной системе.'
echo '[multilib]' >> /etc/pacman.conf
echo 'Include = /etc/pacman.d/mirrorlist' >> /etc/pacman.conf
echo 'IloveCandy' >> /etc/pacman.conf
echo 'Color' >> /etc/pacman.conf
pacman -Syyu --noconfirm

            # gnome gdm\
            # plasma sddm konsole dolphin ark kwrite kcalc spectacle krunner partitionmanager packagekit-qt5\
            # awesome alacritty vicious xcompmgr nitrogen lxappearance light vnstat gsmartcontrol

gui_install="xorg xorg-server xorg-server-devel xorg-xinit xorg-setxkbmap plasma sddm konsole dolphin ark kwrite kcalc spectacle krunner partitionmanager packagekit-qt5"
#  sudo light -As "sysfs/backlight/amdgpu_bl0" 100
# volumeicon gxkb
# nvidia-dkms nvidia-utils lib32-nvidia-utils nvidia-settings vulkan-icd-loader lib32-vulkan-icd-loader lib32-opencl-nvidia opencl-nvidia libxnvctrl
drivers="nvidia-dkms nvidia-utils lib32-nvidia-utils nvidia-settings vulkan-icd-loader lib32-vulkan-icd-loader lib32-opencl-nvidia opencl-nvidia libxnvctrl lib32-mesa-demos mesa-demos libva-vdpau-driver"

echo 'Ставим иксы и драйвера'
pacman -S $drivers --noconfirm --needed
echo 'blacklist nouveau' >> /usr/lib/modprobe.d/nvidia-utils.conf


echo 'Cтавим DM'
# systemctl enable gdm
#systemctl enable sddm

# echo 'gxkb &' > ~/.xinitrc
# echo 'xset b off' >> ~/.xinitrc
# echo 'exec awesome' >> ~/.xinitrc

# echo 'export LIBGL_ALWAYS_SOFTWARE=1' >> ~/.bash_profile
# echo '' >> ~/.bash_profile
# echo 'if [ -z "${DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then' >> ~/.bash_profile
# echo '	  exec startx' >> ~/.bash_profile
# echo 'fi' >> ~/.bash_profile

# mkdir ~/.config/awesome/
# cp /etc/xdg/awesome/rc.lua .config/awesome/
# cp /usr/share/awesome/themes/default/theme.lua .config/awesome/

# echo 'os.execute ("pgrep -u $USER -x volumeicon || (volumeicon &)")' >> ~/.config/awesome/rc.lua
# setxkbmap -layout "us,ru" -option grp:alt_space_toggle

echp 'Ставим AUR'
sudo pacman -S --needed git --noconfirm

mkdir tools
cd tools/

git clone https://aur.archlinux.org/yay.git

cd yay/ && makepkg -si && cd ..

sudo pacman -S telegram-desktop firefox docker lshw util-linux-libs wmctrl steam discord audacity krita kdenlive obs-studio mpg123 mpv ntfs-3g wine winetricks git gvfs ccache grub-customizer neofetch --noconfirm

yay -S onlyoffice-bin visual-studio-code-bin ttf-times-new-roman ventoy-bin gamin protontricks downgrade optimus-manager-qt --noconfirm
# yay -S proton-ge-custom-bin gputest portproton protontricks  yandex-music-player anilibria-winmaclinux timeshift
#  gnome-browser-connector

# echo 'WaylandEnable=false' >> sudo vim /etc/gdm/custom.conf

#sudo mkinitcpio -P
#sudo X -configure
# sudo cp /etc/X11/xorg.conf.backup /etc/X11/xorg.conf

sudo groupadd docker
sudo usermod -aG docker $USER

sudo systemctl enable docker
sudo systemctl start docker

#sudo vim /etc/mkinitcpio.conf 
#MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm crc32c libcrc32c zlib_deflate btrfs)
#sudo /etc/default/grub
#GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3 quiet nvidia_drm.modeset=1"

# sudo docker pull postgres
# sudo docker pull dpage/pgadmin4



# sudo docker run -p 80:80 \
#     -e 'PGADMIN_DEFAULT_EMAIL=user@domain.com' \
#     -e 'PGADMIN_DEFAULT_PASSWORD=SuperSecret' \
#     -d dpage/pgadmin4

# sudo docker run --name some-postgres -e POSTGRES_PASSWORD=mysecretpassword -d postgres
cd $start_dir
