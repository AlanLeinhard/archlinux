#!/bin/bash

read -p 'Введите имя диска: ' disk_name
read -p 'Введите размер диска в Б: ' disk
read -p 'Введите размер оперативной пямяти в ГБ: ' swap
read -p 'Введите имя пользователя: ' user_name
read -p 'Введите пароль пользователя: ' user_pass

loadkeys ru
setfont cyr-sun16

echo '2.3 Синхронизация системных часов'
timedatectl set-ntp true


disk=`expr $disk / 1048576`

efi=550

swap=`expr $swap '*' 1024 '*' 2`

root=`expr $disk - $efi - $swap`

echo '2.4 создание разделов'
(
  echo g;

  echo n;
  echo;
  echo;
  echo +550M;

  echo n;
  echo;
  echo;
  echo +$root'M';

  echo n;
  echo;
  echo;
  echo;

  echo t;
  echo 1;
  echo 1;

  echo t;
  echo 2;
  echo 23;

  echo t;
  echo 3;
  echo 19;

  echo w;
) | fdisk /dev/$disk_name

echo 'Ваша разметка диска'
fdisk -l

echo '2.4.2 Форматирование дисков'
mkfs.fat -F32  /dev/$disk_name'p1'
mkfs.ext4  /dev/$disk_name'p2'
mkswap /dev/$disk_name'p3'

echo '2.4.3 Монтирование дисков'
mount /dev/$disk_name'p2' /mnt
mount --mkdir /dev/$disk_name'p1' /mnt/efi
swapon /dev/$disk_name'p3'

# echo '3.1 Выбор зеркал для загрузки. Ставим зеркало от Яндекс'
# echo "Server = http://mirror.yandex.ru/archlinux/\$repo/os/\$arch" > /etc/pacman.d/mirrorlist

echo '3.2 Установка основных пакетов'
pacstrap /mnt base base-devel linux linux-firmware

echo '3.3 Настройка системы'
genfstab -U /mnt >> /mnt/etc/fstab

# arch-chroot /mnt sh -c arch2.sh $disk_name

arch-chroot /mnt sh -c "$(curl -fsSL https://raw.github.com/AlanLeinhard/archlinux/main/arch2.sh) $disk_name $user_pass $user_name"

reboot