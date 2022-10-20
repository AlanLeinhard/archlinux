

read -p 'Введите имя диска: ' disk_name
read -p 'Введите размер диска в Б: ' disk
read -p 'Введите размер оперативной пямяти в ГБ: ' swap
read -p 'Введите имя пользователя: ' user_name
read -p 'Введите пароль пользователя: ' user_pass

sh test2.sh $disk_name $user_pass $user_name