#!/bin/bash


# sudo pacman-key --init               # Инициализация
# sudo pacman-key --populate archlinux # Получить ключи
# sudo pacman-key --refresh-keys       # Проверить новые и установленные
# sudo pacman -Sy                      # Обновить ключи для всей системы

# sudo pacman -S reflector rsync curl  # Установка reflector и его зависимостей
# sudo reflector --verbose --country 'Russia' -l 25 --sort rate --save /etc/pacman.d/mirrorlist
# sudo nano /etc/pacman.d/mirrorlist                        # Рекомендуем прописывать зеркала Яндекса

sudo pacman -Suy                                          # Обновить зеркала и ключи
sudo pacman -S base-devel git gvfs ccache grub-customizer # Установить зависимости для будущей оптимизации

sudo pacman -S nvidia-dkms nvidia-utils lib32-nvidia-utils nvidia-settings vulkan-icd-loader lib32-vulkan-icd-loader lib32-opencl-nvidia opencl-nvidia libxnvctrl
sudo mkinitcpio -P # Обновляем образы ядра