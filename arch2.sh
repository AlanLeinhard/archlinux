#!/bin/bash
hostname=virt-arch
username=virt_alan

echo 'Прописываем имя компьютера'
echo $hostname > /etc/hostname
ln -svf /usr/share/zoneinfo/Europe/Moscow  /etc/localtime

echo '3.4 Добавляем русскую локаль системы'
echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
echo "ru_RU.UTF-8 UTF-8" >> /etc/locale.gen 

echo 'Обновим текущую локаль системы'
locale-gen

echo 'Указываем язык системы'
echo 'LANG="ru_RU.UTF-8"' > /etc/locale.conf

echo 'Вписываем KEYMAP=ru FONT=cyr-sun16'
echo 'KEYMAP=ru' >> /etc/vconsole.conf
echo 'FONT=cyr-sun16' >> /etc/vconsole.conf

echo '127.0.0.1 localhost' >> /etc/hosts
echo ':1        localhost' >> /etc/hosts
echo '127.0.1.1 $hostname.localdomain $hostname' >> /etc/hosts

echo 'Создаем root пароль'
(
  echo 3571;
  echo 3571;
) | passwd

echo 'Добавляем пользователя'
useradd -m $username

echo 'Устанавливаем пароль пользователя'
(
  echo 3571;
  echo 3571;
) | passwd $username

usermod -aG wheel,audio,video,optical,storage $username
userdbctl groups-of-user $username

pacman -S vim sudo wget htop cups
EDITOR=vim


echo 'Устанавливаем SUDO'
echo '%wheel ALL=(ALL) ALL' >> /etc/sudoers


# echo 'Создадим загрузочный RAM диск'
# mkinitcpio -p linux

echo '3.5 Устанавливаем загрузчик'
pacman -Syy
pacman -S grub
pacman -S efibootmgr dosfstools os-prober mtools

echo 'GRUB_DISABLE_OS_PROBER=false' >> /etc/default/grub

mkdir /boot/EFI
mount /dev/$11 /boot/EFI
grub-install --target=x86_64-efi --bootloader-id=grub_uefi --recheck

echo 'Обновляем grub.cfg'
grub-mkconfig -o /boot/grub/grub.cfg

echo 'Ставим программу для Wi-fi'
pacman -Syyu dhcpcd nmcli
systemctl enable dhcpcd

echo 'Раскомментируем репозиторий multilib Для работы 32-битных приложений в 64-битной системе.'
echo '[multilib]' >> /etc/pacman.conf
echo 'Include = /etc/pacman.d/mirrorlist' >> /etc/pacman.conf
pacman -Syyu

pacman -S dialog wpa_supplicant --noconfirm 


gui_install="xorg xorg-xinit xorg-server xorg-drivers gnome-extra gdm"


echo 'Ставим иксы и драйвера'
pacman -S $gui_install


echo 'Cтавим DM'
systemctl enable gdm

echo 'Ставим шрифты'
pacman -S ttf-liberation ttf-dejavu --noconfirm 

# echo 'Установка базовых программ и пакетов'
# sudo pacman -S reflector firefox firefox-i18n-ru ufw f2fs-tools dosfstools ntfs-3g alsa-lib alsa-utils file-roller p7zip unrar gvfs aspell-ru pulseaudio pavucontrol --noconfirm

# echo "Ставим i3"
# pacman -S i3-gaps polybar dmenu pcmanfm xterm ttf-font-awesome feh gvfs udiskie ristretto tumbler picom jq --noconfirm
    
echo 'Ставим сеть'
pacman -S networkmanager network-manager-applet ppp

echo 'Подключаем автозагрузку менеджера входа и интернет'
systemctl enable NetworkManager

echp 'Ставим AUR'
sudo pacman -S --needed base-devel git

mkdir Downloads/aur
cd Downloads/aur/

it clone https://aur.archlinux.org/yay.git
cd yay/
makepkg -si
cd ..
git clone https://aur.archlinux.org/firefox-bin.git 
cd firefox-bin/
makepkg -si
cd ..
git clone https://aur.archlinux.org/telegram-desktop-bin.git
cd telegram-desktop-bin/
makepkg -si
telegram-desktop 
cd ..
git clone https://aur.archlinux.org/onlyoffice-bin.git
cd onlyoffice-bin/
makepkg -si
makepkg -si
cd ..
git clone https://aur.archlinux.org/visual-studio-code-bin.git 
cd visual-studio-code-bin/ && makepkg -si && cd ..
git clone https://aur.archlinux.org/ttf-times-new-roman.git
cd ttf-times-new-roman/ && makepkg -si && cd ..
sudo pacman -S steam
git clone https://aur.archlinux.org/yandex-music-player.git
ls
cd yandex-music-player/ && makepkg -si && cd ..
git clone https://aur.archlinux.org/discord-rpc-bin.git
cd discord-rpc-bin/ && makepkg -si && cd ..
cd discord-rpc-bin/ && makepkg -si && cd ..
sudo pacman -S discord obs audacity krita kdenlive obs-studio mpg mpg123 mpv ntfs-3g dosfstools gamin gvfs gamin gvfs ntfs-3g dosfstools gamin gvfs ntfs-3g gvfs ntfs-3g wine playonlinux base-devel git gvfs ccache grub-customizer
git clone https://aur.archlinux.org/proton-ge-custom-bin.git
cd proton-ge-custom-bin/ && makepkg -si && cd

echo 'Установка завершена! Перезагрузите систему.'
echo 'Если хотите подключить AUR, установить мои конфиги XFCE, тогда после перезагрзки и входа в систему, установите wget (sudo pacman -S wget) и выполните команду:'
echo 'wget git.io/arch3.sh && sh arch3.sh'
exit
