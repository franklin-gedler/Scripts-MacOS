
comando para ver dependencias faltantes en linux:
ldd /usr/local/pulse/pulseUi | grep "not found"
________________________________________________________________________________________________________________



echo *Gr4lPeron1710-18:55* | sudo -S spctl --master-disable


# Agrega al usuario como admin local
dseditgroup -u admindesp -P *Gr4lPeron1710-18:55* -o edit -a $USER -t user admin


# Cambiar nombre de equipo
sudo scutil --set HostName <new host name>
sudo scutil --set LocalHostName <new host name>
sudo scutil --set ComputerName <new name>


# comando para sacar la MacOS del AD
sudo dsconfigad -f -r -u franklin.gedler -p Sabri-Ele-Frank1801.-.


nomenclatura=$(ioreg -c IOPlatformExpertDevice -d 2 | awk -F\" '/IOPlatformSerialNumber/{print $(NF-1)}')
# pegar a dominio equipo MacOS
sudo dsconfigad -add ar.infra.d -force -computer frankMacOS --domain DC=AR,DC=INFRA,DC=D -username franklin.gedler -password Sabri-Ele-Frank1801.-. -alldomains enable -mobile enable -mobileconfirm disable -useuncpath enable


FVFZW244L413    8UW9-YVOT-POCU-5H2L-NVYL-6PPK




varusr=$(who > /tmp/varusr && awk 'NR < 2 {print $1}' /tmp/varusr | tr -d '[[:space:]]')
idusr=$(id -u $varusr)


echo "<plist><dict><key>Username</key><string>admindesp</string><key>Password</key><string>*Gr4lPeron1710-18:55*</string><key>AdditionalUsers</key><array><dict><key>Username</key><string>user2</string><key>Password</key><string>password2</string></dict></array></dict></plist>" | fdesetup enable -inputplist



ping -c1 google.com &>/dev/null
if [[ $? -ne 0 ]] || [[ "$EUID" != 0 ]]; then
	echo "Este Script requiere root o no tienes conexion a internet"
	exit 1
fi




dsconfigad -show | grep "ar.infra.d" | awk '{print $5}'




#!/bin/bash

bindingshow=$(dsconfigad -show | grep "ar.infra.d" | awk '{print $5}' | tr -d '[[:space:]]')


if [[ "$bindingshow" = "ar.infra.d" ]]; then

	echo "son iguales"
else

	echo "no son iguales"
fi




- VPN PULSE
https://drive.google.com/file/d/14xMnzScgfy7_UAabxgUYkWTrivdE7vF2/view


-VPN Regional

https://drive.google.com/open?id=1_toHq32gqKygfCCyRNRZunQfF9PbNl8S