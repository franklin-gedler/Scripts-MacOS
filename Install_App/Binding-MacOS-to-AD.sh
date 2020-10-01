#!/bin/bash

# Agrega al usuario como admin local
#dseditgroup -u admindesp -P *Gr4lPeron1710-18:55* -o edit -a $USER -t user admin

# Crea la carpeta temporal
TEMPDIR=`mktemp -d`

# me muevo a la carpeta temporal
cd $TEMPDIR

# Muestro donde estoy parado
pwd

# Sincroniza hora de infra.d con la MacOS
echo *Gr4lPeron1710-18:55* | sudo -S sntp -sS infra.d

# Desabilita seguridad pajua de macOS
echo *Gr4lPeron1710-18:55* | sudo -S spctl --master-disable

# Solicita el Nombre de equipo
nomenclatura=$(osascript -e 'Tell application "System Events" to display dialog "Ingresar nombre de equipo (Nomenclatura IT-Support)" default answer ""' -e 'text returned of result' 2>/dev/null)

# asigna nombre de equipo el serial
#nomenclatura=$(ioreg -c IOPlatformExpertDevice -d 2 | awk -F\" '/IOPlatformSerialNumber/{print $(NF-1)}')

# Cambiar nombre de equipo
sudo scutil --set HostName $nomenclatura
sudo scutil --set LocalHostName $nomenclatura
sudo scutil --set ComputerName $nomenclatura

# Solicita nombre de Usuario Admin de Dominio (Usuario de soporte)
usuariosoporte=$(osascript -e 'Tell application "System Events" to display dialog "Ingresar UserName IT-Support" default answer ""' -e 'text returned of result' 2>/dev/null)

# Solicita Clave de Usuario admin de Dominio (Clave Usuario de soporte)
passsoporte=$(osascript -e 'Tell application "System Events" to display dialog "Ingresar Password de Red" with hidden answer default answer ""' -e 'text returned of result' 2>/dev/null)

# guarda en una variable el nombre del equipo
#varnombre=$(uname -n)

# pegar al dominio equipo MacOS
binding=$(sudo dsconfigad -add ar.infra.d -force -computer $nomenclatura --domain DC=AR,DC=INFRA,DC=D -username $usuariosoporte -password $passsoporte -alldomains enable -mobile enable -mobileconfirm disable -useuncpath enable)

err1binding=""
err2binding=""
okbinding="Settings changed successfully"

if [[ $binding = $okbinding ]]; then

	# mje al usuario
	echo ""
	echo ""
	echo "            ================================================="
	echo "            = Se enlazo correctamente al dominio ar.infra.d ="
	echo "            ================================================="
	echo ""
	echo ""	

	# Descargando invgate
	echo "________________________________________________"
	echo "===============>>  Descargando Invgate. . .     "
	echo "------------------------------------------------"
	curl -O https://soportedespe.000webhostapp.com/os-mac/Invgate-MacOS/InvGate-Assets-Agent-Mac-Last-Release.pkg
	echo ""

	# Instalando invgate
	echo "________________________________________________"
	echo "===============>>  Instalando y Config. Invgate."
	echo "------------------------------------------------"
	sudo installer -pkg InvGate-Assets-Agent-Mac-Last-Release.pkg -target /
	cd /usr/local/invgate/assets/agent/
	echo *Gr4lPeron1710-18:55* | sudo -S python generateconfig.py --ip=10.254.112.230 --port=8420
	echo ""
	
	# Descargando Google Chrome
	echo "________________________________________________"
	echo "===============>>  Descargando Google Chrome. . ."
	echo "------------------------------------------------"
	echo *Gr4lPeron1710-18:55* | sudo -S curl -O https://dl.google.com/chrome/mac/stable/GGRO/googlechrome.dmg
	echo ""

	# Instalando Chrome
	echo "________________________________________________"
	echo "===============>>  Instalando Google Chrome. . ."
	echo "------------------------------------------------"
	hdiutil attach googlechrome.dmg -nobrowse 1>/dev/null
	sudo cp -r /Volumes/Google\ Chrome/Google\ Chrome.app /Applications/
	echo ""

	# mje al usuario
	echo ""
	echo ""
	echo "            ================================================="
	echo "            = Created by Franklin Gedler Support Team . . . ="
	echo "            ================================================="
	echo ""
	echo ""

elif [[ $binding != $okbinding ]]; then

	# mje al usuario
	echo ""
	echo "            !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
	echo "            ================================================="
	echo "            ==================== ERROR ======================"
	echo "            ================================================="
	echo "            !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
	echo ""	
	echo " ===== Verificar credenciales de red que se esten ingresando correctamente ====="
	echo " ===== Verificar que la Hora y fecha del equipo este correctas ================="
	echo ""	
fi





