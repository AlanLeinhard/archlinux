# read -p 'Введите размер диска в Б: ' disk

# disk=`expr $disk '/' 2`
disk=$1

echo /dev/$disk'p1'


