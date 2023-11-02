#!/bin/bash

#Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

#Ctrl + C

function ctrl_c(){
	echo -e "\n\n${redColour}[!] Saliendo...${endColour}\n"
	tput cnorm; exit 1
}

trap ctrl_c INT

#Panel de ayuda

function helpPanel(){
	tput civis
	echo -e "\n${yellowColour}[+]${endColour}${greyColour} Uso:${endColour}${purpleColour} $0${endColour}\n"
	echo -e "\t${blueColour}-m)${endColour}${greyColour} Dinero con el que quieres jugar${endColour}"
	echo -e "\t${blueColour}-t)${endColour}${greyColour} Técnica a utilizar${endColour}${purpleColour} (${endColour}${yellowColour}martingala${endColour}${blueColour}/${endColour}${yellowColour}inverseLabrouchere${endColour}${purpleColour})${endColour}"
	echo -e "\t${blueColour}-h)${endColour}${greyColour} Mostrar este panel de ayuda${endColour}\n"
	tput cnorm; exit 1
}

#Técnica de Martingala

function martingala(){
	echo -e "\n${yellowColour}[+]${endColour}${greyColour} Dinero actual:${endColour}${turquoiseColour} $money€${endColour}\n"
	sleep 1
	echo -ne "${yellowColour}[+]${endColour}${greyColour} ¿De cuánto dinero quieres que sea tu primera apuesta? -> ${endColour}" && read initial_bet
	sleep 0.5
	echo -ne "${yellowColour}[+]${endColour}${greyColour} ¿A qué quieres apostar continuamente?${endColour}${purpleColour} (par/impar)${endColour}${greyColour} -> ${endColour}" && read bet_option
	echo -e "\n${yellowColour}[+]${endColour}${greyColour} Vamos a jugar${endColour}${turquoiseColour} $initial_bet€${endColour}${greyColour} al${endColour}${turquoiseColour} $bet_option${endColour}"

	buckup_bet=$initial_bet
	play_counter=1
	bad_plays="[ "
	top_money=""
	tput civis
	while true; do
		money=$(($money-$initial_bet))
#		echo -e "\n${yellowColour}[+]${endColour} ${greyColour}Acabas de apostar ${endColour}${turquoiseColour}$initial_bet€${endColour}${greyColour} y tienes ${endColour}${turquoiseColour}$money€${endColour}"
        random_number="$(($RANDOM % 37))"
#        echo -e "${yellowColour}[+]${endColour}${greyColour} Ha salido el numero${endColour} ${turquoiseColour}$random_number${endColour}"

		if [ ! "$money" -le 0 ]; then
        	if [ "$bet_option" == "par" ]; then
            	if [ "$(($random_number % 2))" -eq 0 ]; then
#                    	echo -e "${yellowColour}[+]${endcolour}${greenColour} Ha salido un numero par,¡Ganaste!${endColour}"
                    	reward=$(($initial_bet*2))
#                    	echo -e "${yellowColour}[+] ${endColour}${greyColour}Has ganado ${endColour}${turquoiseColour}$reward€${endColour}"
                    	money=$(($money+$reward))
#                    	echo -e "${yellowColour}[+] ${endColour}${greyColour}Tienes ${endColour}${turquoiseColour}$money€${endColour}"
                    	initial_bet=$buckup_bet
                    	bad_plays="[ "
                    	top_money=$money
            	else
#                	echo -e "${redColour}[!] Ha salido un numero impar ¡Perdiste! :(${endColour}"
                	initial_bet=$(($initial_bet*2))
                	bad_plays+="$random_number "
#                	echo -e "${yellowColour}[+]${endColour}${greyColour} Te quedan${endColour} ${turquoiseColour}$money€${endColour}"
            	fi

        	else
				if [ "$(($random_number % 2))" -eq 1 ]; then
                    if [ "$random_number" -eq 0 ]; then
#                       echo -e "${redColour}[!] Ha salido 0 :(${endColour}"
                        initial_bet=$(($initial_bet*2))
                        bad_plays+="$random_number "
#                       echo -e "${yellowColour}[+]${endColour}${greyColour} Te quedan${endColour} ${turquoiseColour}$money€${endColour}"
                    else
#                       echo -e "${yellowColour}[+]${endcolour}${greenColour} Ha salido un numero impar,¡Ganaste!${endColour}"
                        reward=$(($initial_bet*2))
#                       echo -e "${yellowColour}[+] ${endColour}${greyColour}Has ganado ${endColour}${turquoiseColour}$reward€${endColour}"
                        money=$(($money+$reward))
#                       echo -e "${yellowColour}[+] ${endColour}${greyColour}Tienes ${endColour}${turquoiseColour}$money€${endColour}"
                        initial_bet=$buckup_bet
                        bad_plays="[ "
                        top_money=$money
                    fi
                else
#                   echo -e "${redColour}[!] Ha salido un numero par ¡Perdiste! :(${endColour}"
                    initial_bet=$(($initial_bet*2))
                    bad_plays+="$random_number "
#                   echo -e "${yellowColour}[+]${endColour}${greyColour} Te quedan${endColour} ${turquoiseColour}$money€${endColour}"
                fi
        	fi

       else
			echo -e "\n${redColour}[!] Te has quedado sin dinero${endColour}\n"
			echo -e "${yellowColour}[+]${endColour}${greyColour} Se han realizado un total de${endColour}${turquoiseColour} $play_counter${endColour}${greyColour} jugadas${endColour}"

			echo -e "\n${yellowColour}[+]${endColour}${greyColour} A continuación se representarán las malas jugadas consecutivas que han salido:\n${endColour}"
			echo -e "${blueColour}$bad_plays]${endColour}\n"
			echo -e "${yellowColour}[+]${endColour}${greyColour} La mayor cantidad de dinero que has poseido han sido:\n\n${endColour}${turquoiseColour} $top_money€${endColour}"
			tput cnorm; exit 0
       fi

    let play_counter+=1
    done
    tput cnorm
}

#Técnica de Labrouchere inversa

function inverseLabrouchere(){
    echo -e "\n${yellowColour}[+]${endColour}${greyColour} Dinero actual:${endColour}${turquoiseColour} $money€${endColour}\n"
    echo -ne "${yellowColour}[+]${endColour}${greyColour} ¿A qué quieres apostar continuamente?${endColour}${purpleColour} (par/impar)${endColour}${greyColour} -> ${endColour}" && read bet_option
    echo -e "${yellowColour}[+] ${endColour}${greyColour}Vamos a jugar con la técnica Labrouchere inversa al ${endColour}${purpleColour}$bet_option${endColour}${greyColour}...${endColour}\n"

	declare -a my_sequence=(1 2 3 4)

    echo -e "${yellowColour}[+]${endColour}${greyColour} Comenzamos con la secuencia${endColour}${turquoiseColour} [${my_sequence[@]}]${endColour}"

	bet=$((${my_sequence[0]} + ${my_sequence[-1]}))

	jugadas_totales=0
	bet_to_renew=$(($money+50))

	tput civis
	while true; do
		let jugadas_totales+=1
		random_number=$(($RANDOM % 37))
		money=$(($money-$bet))
		if [ ! "$money" -lt 0 ]; then
			echo -e "${yellowColour}[+]${endColour}${greyColour} Invertimos ${endColour}${turquoiseColour}$bet€${endColour}"
    		echo -e "${yellowColour}[+]${endColour}${greyColour} Tienes${endColour}${turquoiseColour}$money€${endColour}"

			echo -e "\n${yellowColour}[+]${endColour}${greyColour} Ha salido el número ${endColour}${turquoiseColour}$random_number${endColour}"

			if [ "$bet_option" == "par" ]; then
				if [ "$(($random_number % 2))" -eq 0 ] && [ "$random_number" -ne 0 ]; then
					echo -e "${yellowColour}[+]${endColour}${greenColour} El número es par, ¡ganaste!${endColour}"
					reward=$(($bet*2))
					let money+=$reward
					echo -e "${yellowColour}[+]${endColour}${greyColour} Tienes${endColour}${turquoiseColour} $money€${endColour}"

					if [ $money -gt $bet_to_renew ]; then
                		echo -e "${yellowColour}[+] ${endColour}${greyColour}Se ha superado el tope de ${endColour}${turquoiseColour}$bet_to_renew€ ${endColour}${greyColour}renovamos la secuencia${endColour}"
                		bet_to_renew=$(($bet_to_renew + 50))
               			echo -e "${yellowColour}[+]${endColour}${greyColour} Ahora el tope es${endColour}${turquoiseColour} $bet_to_renew${endColour}"
                		my_sequence=(1 2 3 4)
                		bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
                		echo -e "${yellowColour}[+]${endColour}${greyColour} La secuencia vuelve al principio:${endColour}${tuquoiseColour} [$my_sequence]${endColour}"

                	else

						my_sequence+=($bet)
						my_sequence=(${my_sequence[@]})

						echo -e "${yellowColour}[+]${endColour}${endColour} ${greyColour}Nuestra nueva secuencia es${endColour}${turquoiseColour} [${my_sequence[@]}]${endColour}"
						if [ "${#my_sequence[@]}" -ne 1 ] && [ "${#my_sequence[@]}" -ne 0 ]; then
							bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
						elif [ "${#my_sequence[@]}" -eq 1 ]; then
							bet=${my_sequence[0]}
						else
                	    	echo -e "${redColour}[!] Hemos perdido nuestra secuencia${endColour}"
                	    	my_sequence=(1 2 3 4)
                	    	echo -e "${yellowColour}[+]${endColour}${greyColour} Restablecemos la secuencia a ${endColour}${turquoiseColour}[${my_sequence[@]}]${endColour}"
                	    	bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
						fi
					fi

				elif [ $(($random_number % 2)) -eq 1 ] || [ "${random_number}" -eq 0 ]; then
					if [ $(($random_number % 2)) -eq 1 ]; then
						echo -e "${redColour}[!] El numero es impar, ¡Perdiste! :(${endColour}"
					else
						echo -e "${redColour}[!] Ha salido el numero 0, ¡Perdiste! :(${endColour}"
					fi

					if [ $money -lt $(($bet_to_renew-100)) ]; then
                        bet_to_renew=$(($bet_to_renew - 100))
                        echo -e "${yellowColour}[+]${endColour}${greyColour} Estas por debajo del mínimo establecido, se reestablece la secuenca:${endColour}${turquoiseColour} [${my_sequence}]${endColour}"
                        echo -e "${yellowColour}[+]${endColour} ${greyColour}El tope ha sido reestablecido a ${endColour}${turquoiseColour}${bet_to_renew}€${endColour}"

                        unset my_sequence[0]
                        unset my_sequence[-1] 2>/dev/null

                        my_sequence=(${my_sequence[@]})

                        echo -e "${yellowColour}[+]${endColour}${endColour} ${greyColour}Nuestra nueva secuencia es${endColour}${turquoiseColour} [${my_sequence[@]}]${endColour}"
                        if [ "${#my_sequence[@]}" -ne 1 ] && [ "${#my_sequence[@]}" -ne 0 ]; then
                            bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
                        elif [ "${#my_sequence[@]}" -eq 1 ]; then
                            bet=${my_sequence[0]}
                        else
                            echo -e "${redColour}[!] Hemos perdido nuestra secuencia${endColour}"
                            my_sequence=(1 2 3 4)
                            echo -e "${yellowColour}[+]${endColour}${greyColour} Restablecemos la secuencia a ${endColour}${turquoiseColour}[${my_sequence[@]}]${endColour}"
                            bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
                        fi
                    else
						unset my_sequence[0]
						unset my_sequence[-1] 2>/dev/null

	                	my_sequence=(${my_sequence[@]})

						echo -e "${yellowColour}[+] ${endColour}${greyColour}La secuencia se nos queda de la siguiente forma: ${endColour}${turquoiseColour}[${my_sequence[@]}]${endColour}"
						if [ "${#my_sequence[@]}" -ne 1 ] && [ "${#my_sequence[@]}" -ne 0 ]; then
            	    	    bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
                		elif [ "${#my_sequence[@]}" -eq 1 ]; then
                		    bet=${my_sequence[0]}
                		else
                			echo -e "${redColour}[!] Hemos perdido nuestra secuencia${endColour}"
                			my_sequence=(1 2 3 4)
                			echo -e "${yellowColour}[+]${endColour}${greyColour} Restablecemos la secuencia a ${endColour}${turquoiseColour}[${my_sequence[@]}]${endColour}"
                			bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
            			fi
            		fi
				fi
        	fi
		else
			echo -e "\n${redColour}[!] Te has quedado sin dinero, ¡La casa siempre gana!${endColour}"
			echo -e "\n${yellowColour}[+]${endColour}${greyColour} Has realizado ${endColour}${turquoiseColour}${jugadas_totales} jugadas${endColour}"
			tput cnorm; exit 1
		fi
#		sleep 0.4
	done
    tput cnorm

}

#Receptor de parametros

while getopts "m:t:h" arg; do
	case $arg in
		m) money=$OPTARG;;
		t) technique=$OPTARG;;
		h) helpPanel;;
	esac
done

#Flujo del programa

if [ $money ] && [ $technique ]; then
	if [ "$technique" == "martingala" ]; then
		martingala
	elif [ "$technique" == "inverseLabrouchere" ]; then
		inverseLabrouchere
	else
		echo -e "\n${redColour}[!] La técnica escogida no existe o no está registrada${endColour}"
		helpPanel
	fi
else
	helpPanel
fi
