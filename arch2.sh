#!/bin/bash


read -p 'Введите имя диска: ' disk_name
read -p 'Введите имя пользователя: ' user_name
read -p 'Введите пароль пользователя: ' user_pass

hostname=$user_name-arch-laptop

echo "имя диска $disk_name"
echo "пароль $user_pass"
echo "имя пользователя $user_name"
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
systemctl enable dhcpcd NetworkManager ufw bluetooth
# systemctl start dhcpcd NetworkManager ufw bluetooth


read -p 'Введите temper: ' temper

echo 'Создаем root пароль'
(
  echo $user_pass;
  echo $user_pass;
) | passwd

read -p 'Введите temper: ' temper

echo 'Добавляем пользователя'
useradd -m $username

echo 'Устанавливаем пароль пользователя'
(
  echo $user_pass;
  echo $user_pass;
) | passwd $username

read -p 'Введите temper: ' temper

usermod -aG wheel,audio,video,optical,storage $username
userdbctl groups-of-user $username

read -p 'Введите temper: ' temper

pacman -S vim sudo wget htop iw --noconfirm
EDITOR=vim

read -p 'Введите temper: ' temper


echo 'Устанавливаем SUDO'
echo '%wheel ALL=(ALL) ALL' >> /etc/sudoers


# echo 'Создадим загрузочный RAM диск'
# mkinitcpio -p linux

read -p 'Введите temper: ' temper

echo '3.5 Устанавливаем загрузчик'
pacman -Syy --noconfirm
pacman -S grub --noconfirm
pacman -S efibootmgr dosfstools os-prober mtools --noconfirm

echo 'GRUB_DISABLE_OS_PROBER=false' >> /etc/default/grub

mount --mkdir /dev/$disk_namep1 /boot/EFI
grub-install --target=x86_64-efi --bootloader-id=grub_uefi --recheck

echo 'Обновляем grub.cfg'
grub-mkconfig -o /boot/grub/grub.cfg

curl -fsSL https://raw.github.com/AlanLeinhard/archlinux/main/arch3.sh -o /home/$user_name/arch3.sh
read

echo 'Установка завершена! Перезагрузите систему.'
exit
