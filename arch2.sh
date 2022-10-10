#!/bin/bash
hostname=arch-pc
username=alan

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

mkdir /boot/EFI
mount /dev/$1p1 /boot/EFI
grub-install --target=x86_64-efi --bootloader-id=grub_uefi --recheck

echo 'Обновляем grub.cfg'
grub-mkconfig -o /boot/grub/grub.cfg


echo 'Установка завершена! Перезагрузите систему.'
exit
