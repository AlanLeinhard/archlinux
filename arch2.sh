#!/bin/bash


# read -p 'Введите имя диска: ' disk_name
# post=''
# if [[ $disk_name == nvme* ]] 
# then
# post='p'
# fi
# read -p 'Введите имя пользователя: ' user_name
# read -p 'Введите пароль пользователя: ' user_pass
source /install.env

# echo "имя диска $disk_name"
echo "имя компьютера $hostname"
echo "пароль root $root_pass"
echo "имя пользователя $user_name"
echo "пароль пользователя $user_pass"
read -p 'Верно?' temper

echo 'Прописываем имя компьютера'
echo $hostname > /etc/hostname

echo '127.0.0.1 localhost' >> /etc/hosts
echo ':1        localhost' >> /etc/hosts
echo '127.0.1.1 $hostname.localdomain $hostname' >> /etc/hosts

ln -svf /usr/share/zoneinfo/Asia/Yekaterinburg  /etc/localtime
hwclock --systohc

echo '3.4 Добавляем русскую локаль системы'
echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
echo "ru_RU.UTF-8 UTF-8" >> /etc/locale.gen 

echo 'Обновим текущую локаль системы'
locale-gen

echo 'Указываем язык системы'
# echo "en_US.UTF-8 UTF-8" > /etc/locale.conf
echo "ru_RU.UTF-8 UTF-8" > /etc/locale.conf

echo 'Вписываем KEYMAP=ru FONT=cyr-sun16'
echo 'KEYMAP=ruwin_alt-UTF-8' >> /etc/vconsole.conf
echo 'FONT=UniCyr_8x16' >> /etc/vconsole.conf

echo 'Ставим сеть'
pacman -Syyu dhcpcd networkmanager ufw bluez bluez-utils --noconfirm

echo 'Подключаем автозагрузку менеджера входа и интернет'
systemctl enable dhcpcd NetworkManager ufw bluetooth
# systemctl start dhcpcd NetworkManager ufw bluetooth


echo 'Создаем root пароль'
(
  echo $root_pass;
  echo $root_pass;
) | passwd


echo 'Добавляем пользователя'
useradd -m $user_name

echo 'Устанавливаем пароль пользователя'
(
  echo $user_pass;
  echo $user_pass;
) | passwd $user_name


usermod -aG wheel,audio,video,optical,storage $user_name
userdbctl groups-of-user $user_name


pacman -S sudo wget htop iw git --noconfirm
EDITOR=vim



echo 'Устанавливаем SUDO'
echo '%wheel ALL=(ALL) ALL' >> /etc/sudoers



# echo 'Создадим загрузочный RAM диск'
# mkinitcpio -p linux


echo '3.5 Устанавливаем загрузчик'
pacman -Syy grub efibootmgr dosfstools os-prober mtools --noconfirm

echo 'GRUB_DISABLE_OS_PROBER=true' >> /etc/default/grub

# mount --mkdir /dev/$disk_name$post'1' /boot/EFI
grub-install /dev/$disk_name

echo 'Обновляем grub.cfg'
grub-mkconfig -o /boot/grub/grub.cfg

# pacman -S --needed xorg sddm plasma kde-applications --noconfirm
# systemctl enable sddm

curl -fsSL https://raw.github.com/AlanLeinhard/archlinux/main/arch3.sh -o /home/$user_name/arch3.sh

echo 'Установка завершена! Перезагрузите систему.'
exit
