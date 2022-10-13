#!/bin/bash


sudo pacman-key --init --noconfirm               # Инициализация
sudo pacman-key --populate archlinux --noconfirm # Получить ключи
sudo pacman-key --refresh-keys --noconfirm       # Проверить новые и установленные
sudo pacman -Sy --noconfirm                      # Обновить ключи для всей системы

sudo pacman -S reflector rsync curl --noconfirm   # Установка reflector и его зависимостей
sudo reflector --verbose --country 'Germany' -l 25 --sort rate --save /etc/pacman.d/mirrorlist --noconfirm 
sudo nano /etc/pacman.d/mirrorlist --noconfirm                         # Рекомендуем прописывать зеркала Яндекса

sudo pacman -Suy --noconfirm                                          # Обновить зеркала и ключи
sudo pacman -S base-devel git gvfs ccache grub-customizer --noconfirm # Установить зависимости для будущей оптимизации

sudo pacman -S nvidia nvidia-utils lib32-nvidia-utils nvidia-settings vulkan-icd-loader lib32-vulkan-icd-loader lib32-opencl-nvidia opencl-nvidia xorg-server-devel libxnvctrl --noconfirm
sudo mkinitcpio -P # Обновляем образы ядра

sudo nvidia-xconfig  # Сгенерируем дефолтный конфиг и выполним перезагрузку через команду reboot
# sudo nvidia-settings # Открыть панель Nvidia