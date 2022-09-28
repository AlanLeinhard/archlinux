#!/bin/bash


loadkeys ru
setfont cyr-sun16

echo '2.3 Синхронизация системных часов'
timedatectl set-ntp true


disk=`expr $1 / 1048576`

echo $disk

efi=550

root=20480

swap=`expr $2 '*' 1024`

home=`expr $disk - $efi - $root - $swap`

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
  echo +20G;

  echo n;
  echo;
  echo;
  echo +$home'M';

  echo n;
  echo;
  echo;
  echo;

  echo t;
  echo 1;
  echo 1;

  echo t;
  echo 4;
  echo 19;

  echo w;
) | fdisk /dev/$3

echo 'Ваша разметка диска'
fdisk -l

echo '2.4.2 Форматирование дисков'
mkfs.fat -F32  /dev/$31
mkfs.ext4  /dev/$32
mkfs.ext4  /dev/$33
mkswap /dev/$34

echo '2.4.3 Монтирование дисков'
mount /dev/$32 /mnt
mkdir /mnt/{efi,home}
mount /dev/$31 /mnt/efi
mount /dev/$33 /mnt/home
swapon /dev/$34

echo '3.1 Выбор зеркал для загрузки. Ставим зеркало от Яндекс'
echo "Server = http://mirror.yandex.ru/archlinux/\$repo/os/\$arch" > /etc/pacman.d/mirrorlist

echo '3.2 Установка основных пакетов'
pacstrap /mnt base base-devel linux linux-firmware nano dhcpcd netctl

echo '3.3 Настройка системы'
genfstab -U /mnt >> /mnt/etc/fstab

# arch-chroot /mnt sh -c arch2.sh $3

arch-chroot /mnt sh -c "$(curl -fsSL https://raw.github.com/AlanLeinhard/archlinux/main/arch2.sh) $3"
