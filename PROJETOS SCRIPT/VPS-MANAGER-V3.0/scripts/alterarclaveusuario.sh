#!/bin/bash
tput setaf 7 ; tput setab 4 ; tput bold ; printf '%35s%s%-10s\n' "Alterar contrase�a de Usu�rio" ; tput sgr0
tput bold ; echo "" ; echo "Lista de usu�rios:" ; echo "" ; tput sgr0
tput setaf 3 ; tput bold ; awk -F : '$3 >= 500 { print $1 }' /etc/passwd | grep -v '^nobody' ; echo "" ; tput sgr0
read -p "Escribe el nombre de usuario para cambiar la contrase�a: " user
if [[ -z $user ]]
then
	tput setaf 7 ; tput setab 4 ; tput bold ; echo "" ; echo "Ha introducido un nombre de usuario vac�o o no v�lido!" ; echo "" ; tput sgr0
	exit 1
else
	if [[ `grep -c /$user: /etc/passwd` -ne 0 ]]
	then
		read -p "Introducir una nueva contrase�a para el usuario: " password
		sizepass=$(echo ${#password})
		if [[ $sizepass -lt 6 ]]
		then
			tput setaf 7 ; tput setab 4 ; tput bold ; echo "" ; echo "La contrase�a no ha cambiado!" ; echo "Ha introducido una contrase�a muy corto!" ; echo "Para mantener el uso seguro del usuario al menos 6 caracteres" ; echo "combinando diferentes letras y n�meros." ; echo "" ; tput sgr0
			exit 1
		else
			ps x | grep $user | grep -v grep | grep -v pt > /tmp/rem
			if [[ `grep -c $user /tmp/rem` -eq 0 ]]
			then
				echo "$user:$password" | chpasswd
				tput setaf 7 ; tput setab 1 ; tput bold ; echo "" ; echo "  la contrase�a  del $usuario se cambi� a: $password" ; echo "" ; tput sgr0
				exit 1
			else
				echo ""
				tput setaf 7 ; tput setab 4 ; tput bold ; echo "Usu�rio conectado. Desconectando..." ; tput sgr0
				pkill -f $user
				echo "$user:$password" | chpasswd
				tput setaf 7 ; tput setab 1 ; tput bold ; echo "" ; echo "El $ usuario contrase�a de usuario se cambi� a : $password" ; echo "" ; tput sgr0
				exit 1
			fi
		fi
	else
		tput setaf 7 ; tput setab 4 ; tput bold ; echo "" ; echo "El usuario o $user no existe!" ; echo "" ; tput sgr0
	fi
fi