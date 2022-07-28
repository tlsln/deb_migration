#!/bin/bash

server_name=$(hostname)

function show_file() {
	echo "Sprawdzam czy plik istnieje, wyświetlam jego zawartość"
	read -p 'Podaj ścieżkę katalogu: ' catalogname
	read -p 'Nazwa pliku: ' filename

		if [ -e "$catalogname/$filename" ]; then
			cat "$catalogname/$filename"
		else
			echo "$catalogname/$filename --> Nie takiego pliku!"
		fi
}

function cpu_check() {
    echo ""
	echo "CPU load on ${server_name} is: "
    echo ""
	uptime
    echo ""
}



function all_checks() {
	show_file
	cpu_check
}

menu(){
echo -ne "
Menu wyboru
1) Memory usage
2) CPU load
0) Exit
'Choose an option:"
        read a
        case $a in
	        1) memory_check ; menu ;;
	        2) cpu_check ; menu ;;
		0) exit 0 ;;
		*) echo -e $red"Wrong option."$clear; WrongCommand;;
        esac
}

#call
menu