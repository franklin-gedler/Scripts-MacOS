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
curl -O https://soportedespe.000webhostapp.com/os-mac/file-vpn-regional/Endpoint_Security_VPN_E80.71.pkg
curl -O https://soportedespe.000webhostapp.com/os-mac/file-vpn-regional/file-not-hidden/Trac.config
curl -O https://soportedespe.000webhostapp.com/os-mac/file-vpn-regional/file-not-hidden/Trac.defaults
curl -O https://soportedespe.000webhostapp.com/os-mac/file-vpn-regional/file-not-hidden/LangPack1.xml

# password sudo
netpass=$(osascript -e 'Tell application "System Events" to display dialog "Ingresar Password de Usuario Local o de Red" with hidden answer default answer ""' -e 'text returned of result' 2>/dev/null)

# Desabilita seguridad pajua de macOS
echo $netpass | sudo -S spctl --master-disable

# Instalando Check Point
echo ""
echo "===============>>  Instalando . . ."
echo ""
sudo installer -pkg Endpoint_Security_VPN_E80.71.pkg -target /

# Habilita seguridad pajua de macOS
#sudo spctl --master-enable

# Down Service
sudo launchctl unload /Library/LaunchDaemons/com.checkpoint.epc.service.plist

# Genera un codigo uuid
newuuid=$(uuidgen)

# Escribo el uuid en el archivo de conf.
perl -i -pe "s/varuuid/$newuuid/g" LangPack1.xml

# Copio los archivos de config
sudo cp LangPack1.xml Trac.* /Library/Application\ Support/Checkpoint/Endpoint\ Connect/

# Up Service
sudo launchctl load /Library/LaunchDaemons/com.checkpoint.epc.service.plist

# Mje al usuario
echo ""
echo ""
echo "            ================================================="
echo "            = Created by Franklin Gedler Support Team . . . ="
echo "            ================================================="
echo "            =            CheckPoint Instalado . . .         ="
echo "            =                   Ejoy =)                     ="
echo "            ================================================="
echo ""
echo ""
