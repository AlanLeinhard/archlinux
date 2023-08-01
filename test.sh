
echo 42949672960
read -p 'Введите имя диска: ' disk_name

post=''

if [[ $disk_name == nvme* ]] 
then
post='p'
fi


read -p 'Введите размер диска в Б: ' disk
read -p 'Введите размер оперативной пямяти в ГБ: ' swap


disk=`expr $disk / 1048576`

efi=550

swap=`expr $swap '*' 1024 '/' 2`

root=20

home=`expr $disk - $efi - $root '*' 1024 - $swap`
echo $efi 
echo $root 
echo $home 
echo $swap