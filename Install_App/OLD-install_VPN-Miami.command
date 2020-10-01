#!/bin/bash

# Agrega al usuario como admin local
dseditgroup -u admindesp -P *Gr4lPeron1710-18:55* -o edit -a $USER -t user admin

# Crea la carpeta temporal
TEMPDIR=`mktemp -d`

# me muevo a la carpeta temporal
cd $TEMPDIR

# Muestro donde estoy parado
pwd

# Descargas
curl -O https://soportedespe.000webhostapp.com/os-mac/file-vpn-miami/PulseSecure.pkg
curl -O https://soportedespe.000webhostapp.com/os-mac/file-vpn-miami/connstore.dat
curl -O https://soportedespe.000webhostapp.com/os-mac/file-vpn-miami/S-501.dat

# password sudo
netpass=$(osascript -e 'Tell application "System Events" to display dialog "Ingresar Password de Usuario Local o de Red" with hidden answer default answer ""' -e 'text returned of result' 2>/dev/null)

# Desabilita seguridad pajua de macOS
echo $netpass | sudo -S spctl --master-disable

# Instalo el paquete
echo ""
echo "===============>>  Instalando . . ."
echo ""
sudo installer -pkg PulseSecure.pkg -target /

# Extraigo el ID asignado y lo guardo en una variable
varuuid=`cat /Library/Application\ Support/Pulse\ Secure/Pulse/DeviceId` && echo 'DeviceID=' $varuuid

# Genero ive y lo guardo en una variable
ive=$(uuidgen | sed "s/-//g") && echo 'ive=' $ive

# Me muevo al directorio temporal
cd $TEMPDIR

# Escribo $varuuid y $ive en los archivos de config
perl -i -pe "s/newive/$ive/g" S-501.dat
perl -i -pe "s/varuuid/$varuuid/g" connstore.dat 
perl -i -pe "s/newive/$ive/g" connstore.dat

# Down service
sudo launchctl unload /Library/LaunchDaemons/net.pulsesecure.AccessService.plist

# muevo los archivos de confi
sudo cp S-501.dat connstore.dat /Library/Application\ Support/Pulse\ Secure/Pulse/ 

# Up Service
sudo launchctl load /Library/LaunchDaemons/net.pulsesecure.AccessService.plist

# Habilita seguridad pajua de macOS
#sudo spctl --master-enable

# mje al usuario
echo ""
echo ""
echo "            ================================================="
echo "            = Created by Franklin Gedler Support Team . . . ="
echo "            ================================================="
echo "            =           Pulse Secure Instalado . . .        ="
echo "            =                  Ejoy =)                      ="
echo "            ================================================="
echo ""
echo ""
