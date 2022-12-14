#!/bin/bash
hostname=$3-arch-laptop
username=$3

echo "имя диска $1"
echo "пароль $2"
echo "имя пользователя $3"
read -p 'Верно?' qwertyuioiuytrertyuuytre

echo 'Прописываем имя компьютера'
echo $hostname > /etc/hostname

echo '127.0.0.1 localhost' >> /etc/hosts
echo ':1        localhost' >> /etc/hosts
echo '127.0.1.1 $hostname.localdomain $hostname' >> /etc/hosts

ln -svf /usr/share/zoneinfo/Europe/Moscow  /etc/localtime
hwclock --systohc

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

echo 'Ставим сеть'
pacman -Syyu dhcpcd networkmanager ufw bluez bluez-utils --noconfirm

echo 'Подключаем автозагрузку менеджера входа и интернет'
systemctl enable dhcpcd NetworkManager ufw bluetooth.service
systemctl start dhcpcd NetworkManager ufw bluetooth.service

echo 'Создаем root пароль'
(
  echo $2;
  echo $2;
) | passwd

echo 'Добавляем пользователя'
useradd -m $username

echo 'Устанавливаем пароль пользователя'
(
  echo $2;
  echo $2;
) | passwd $username

usermod -aG wheel,audio,video,optical,storage $username
userdbctl groups-of-user $username

pacman -S vim sudo wget htop iw --noconfirm
EDITOR=vim


echo 'Устанавливаем SUDO'
echo '%wheel ALL=(ALL) ALL' >> /etc/sudoers


# echo 'Создадим загрузочный RAM диск'
# mkinitcpio -p linux

echo '3.5 Устанавливаем загрузчик'
pacman -Syy --noconfirm
pacman -S grub --noconfirm
pacman -S efibootmgr dosfstools os-prober mtools --noconfirm

echo 'GRUB_DISABLE_OS_PROBER=false' >> /etc/default/grub

mount --mkdir /dev/$1p1 /boot/EFI
grub-install --target=x86_64-efi --bootloader-id=grub_uefi --recheck

echo 'Обновляем grub.cfg'
grub-mkconfig -o /boot/grub/grub.cfg

curl -fsSL https://raw.github.com/AlanLeinhard/archlinux/main/arch2.sh -o /home/$3/arch3.sh

echo 'Установка завершена! Перезагрузите систему.'
exit
