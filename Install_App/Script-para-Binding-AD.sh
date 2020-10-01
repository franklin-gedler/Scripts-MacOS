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
#nomenclatura=$(osascript -e 'Tell application "System Events" to display dialog "Ingresar nombre de equipo (Nomenclatura IT-Support)" default answer ""' -e 'text returned of result' 2>/dev/null)
nomenclatura=$(ioreg -c IOPlatformExpertDevice -d 2 | awk -F\" '/IOPlatformSerialNumber/{print $(NF-1)}')

# Cambiar nombre de equipo
sudo scutil --set HostName AR$nomenclatura
sudo scutil --set LocalHostName AR$nomenclatura
sudo scutil --set ComputerName AR$nomenclatura

# Solicita nombre de Usuario Admin de Dominio (Usuario de soporte)
#usuariosoporte=$(osascript -e 'Tell application "System Events" to display dialog "Ingresar UserName IT-Support" default answer ""' -e 'text returned of result' 2>/dev/null)

# Solicita Clave de Usuario admin de Dominio (Clave Usuario de soporte)
#passsoporte=$(osascript -e 'Tell application "System Events" to display dialog "Ingresar Password de Red del Usuario: '$usuariosoporte'" with hidden answer default answer ""' -e 'text returned of result' 2>/dev/null)

# guarda en una variable el nombre del equipo
#varnombre=$(uname -n)

# pegar al dominio equipo MacOS
binding=$(sudo dsconfigad -add ar.infra.d -force -computer $nomenclatura --domain DC=AR,DC=INFRA,DC=D -username franklin.gedler -password Sabrina-Stella-1801.-. -alldomains enable -mobile enable -mobileconfirm disable -useuncpath enable)
