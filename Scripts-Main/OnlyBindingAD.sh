#!/bin/bash

InputCredentials(){
    usrSoporte=$(osascript \
        -e 'Tell application "System Events" to display dialog "Usuario de Soporte:" giving up after 600 default answer "Nombre.Apellido" buttons {"OK"}' \
        -e 'text returned of result' 2>/dev/null)

	passSoporte=$(osascript \
        -e 'Tell application "System Events" to display dialog "Password de: '$usrSoporte'" giving up after 600 with hidden answer default answer "" buttons {"OK"}' \
        -e 'text returned of result' 2>/dev/null)
}
###############################################################################
#     SOLO CHILE OJO OJO OJO OJO
##############################################################################
ping -c1 google.com &>/dev/null
if [[ $? -ne 0 ]] || [[ "$EUID" != 0 ]]; then
	echo "========================================================="
	echo "Este Script requiere sudo o no tienes conexion a internet"
	echo "========================================================="
	exit 1
else

    NameComputer=$(hostname)
    InputCredentials
    dsconfigad -add cl.infra.d -force -computer $NameComputer --domain DC=CL,DC=INFRA,DC=D -username $usrSoporte -password $passSoporte -alldomains enable -mobile enable -mobileconfirm disable -useuncpath enable
    dsconfigad -passInterval 0
fi


