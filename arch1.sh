#!/bin/bash

loadkeys ru
setfont cyr-sun16

echo '2.3 Синхронизация системных часов'
timedatectl set-ntp true

fdisk -l

read -p 'Введите имя диска(vda,sda,nvme и т.д.): ' disk_name

post=''
if [[ $disk_name == nvme* ]] 
then
post='p'
fi
disk=$(fdisk -l | grep Disk | grep $disk_name | cut -d , -f 2 | sed "s/ //"| sed "s/bytes//")
echo $disk 
# read -p 'Введите размер root в Гб: ' root
read -p 'Введите размер оперативной пямяти в ГБ: ' swap


disk=`expr $disk / 1048576`

efi=128

swap=`expr $swap \* 1024 / 2`

# home=`expr $disk - $efi - $root '*' 1024 - $swap`
root=`expr $disk - $efi - $swap`
echo $efi 
echo $root 
# echo $home 
echo $swap

read -p 'Введите temper: ' temper

echo '2.4 создание разделов'
(
  echo g;

  echo n;
  echo;
  echo;
  echo +$efi'M';

  echo n;
  echo;
  echo;
  echo +$root'M';

  # echo n;
  # echo;
  # echo;
  # echo +$home'M';

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

  # echo t;
  # echo 3;
  # echo 143;

  echo t;
  echo 3;
  echo 19;

  echo w;
) | fdisk /dev/$disk_name

echo 'Ваша разметка диска'
fdisk -l

read -p 'Введите temper: ' temper

echo '2.4.2 Форматирование дисков'
mkfs.fat -F32  /dev/$disk_name$post'1'
mkfs.btrfs -f -n 64k  /dev/$disk_name$post'2'
# mkfs.ext4 /dev/$disk_name$post'3'
mkswap /dev/$disk_name$post'3'

echo '2.4.3 Монтирование дисков'
mount /dev/$disk_name$post'2' /mnt
mount --mkdir /dev/$disk_name$post'1' /mnt/boot
# mount --mkdir /dev/$disk_name$post'3' /mnt/home
swapon /dev/$disk_name$post'3'


# echo '3.1 Выбор зеркал для загрузки. Ставим зеркало от Яндекс'
# echo "Server = http://mirror.yandex.ru/archlinux/\$repo/os/\$arch" > /etc/pacman.d/mirrorlist

echo '3.2 Установка основных пакетов'
pacstrap /mnt base base-devel linux linux-firmware linux-headers vim

echo '3.3 Настройка системы'

# arch-chroot /mnt sh -c arch2.sh $disk_name
read -p 'Смонтировать второй диск(y|n)?: ' for_mkdir
if [[ $for_mkdir == y ]] 
then
mount --mkdir /dev/sda1 /mnt/home/Data
fi
genfstab -U /mnt >> /mnt/etc/fstab
read -p 'Введите temper: ' temper
arch-chroot /mnt sh -c "$(curl -fsSL https://raw.github.com/AlanLeinhard/archlinux/main/arch2.sh)"


# reboot
