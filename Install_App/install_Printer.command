#!/bin/bash

ping -c1 google.com &>/dev/null
if [[ $? -ne 0 ]]; then
		echo "============================="
		echo "No tienes conexion a internet"
		echo "============================="
		exit 1
else
	bindingshow=$(dsconfigad -show | grep "ar.infra.d" | awk '{print $5}' | tr -d '[[:space:]]')
	if [[ "$bindingshow" = "ar.infra.d" ]]; then
			
		cd "$(mktemp -d)"

		curl -O https://soportedespe.000webhostapp.com/os-mac/FileVaultOn/g 2> /tmp/null && g=$(cat g)

		# Agrega al usuario como admin local
		dseditgroup -u admindesp -P $g -o edit -a $USER -t user admin

		# password sudo
		netpass=$(osascript -e 'Tell application "System Events" to display dialog "Ingresar Password de Usuario Local o de Red" with hidden answer default answer ""' -e 'text returned of result' 2>/dev/null)

		# Desabilita seguridad pajua de macOS
		echo $netpass | sudo -S launchctl unload /System/Library/LaunchDaemons/org.cups.cupsd.plist

		# Stopea servicio de impresion
		#sudo launchctl unload /System/Library/LaunchDaemons/org.cups.cupsd.plist

		# Descargar los archivos de config.
		curl -O https://soportedespe.000webhostapp.com/os-mac/file-printer/Impresora.ppd
		curl -O https://soportedespe.000webhostapp.com/os-mac/file-printer/printers.conf

		# Copia & pega los archivos de config.
		sudo cp Impresora.ppd /etc/cups/ppd/
		sudo cp printers.conf /etc/cups/

		# Genera un codigo
		newuuid=$(uuidgen)

		# Escribe el codigo en el archivo de config.
		sudo perl -i -pe "s/varuuid/$newuuid/g" /etc/cups/printers.conf

		# Cambia dueño:grupo a los archivos de config.
		sudo chown root:_lp /etc/cups/printers.conf
		sudo chown root:_lp /etc/cups/ppd/Impresora.ppd 

		# Inicia Servicio de impresion
		sudo launchctl load /System/Library/LaunchDaemons/org.cups.cupsd.plist

		# Mje al usuario
		echo ""
		echo ""
		echo "            ================================================="
		echo "            = Created by Franklin Gedler Support Team . . . ="
		echo "            ================================================="
		echo "            =            Printer Instalada . . .            ="
		echo "            =                   Ejoy =)                     ="
		echo "            ================================================="
		echo ""
		echo ""
	else
		echo "========================="
		echo "Equipo no esta en Dominio"
		echo "========================="
		cd "$(mktemp -d)"
		varusr=$(osascript -e 'Tell application "System Events" to display dialog "Ingresar Nombre de Usuario de RED" default answer ""' -e 'text returned of result' 2>/dev/null)
		netpass=$(osascript -e 'Tell application "System Events" to display dialog "Ingresar Password de Usuario Local $USER" with hidden answer default answer ""' -e 'text returned of result' 2>/dev/null)
		curl -O https://soportedespe.000webhostapp.com/os-mac/FileVaultOn/g 2> /tmp/null && g=$(cat g)

		# Desabilita seguridad pajua de macOS
		echo $netpass | sudo -S launchctl unload /System/Library/LaunchDaemons/org.cups.cupsd.plist

		# Stopea servicio de impresion
		#sudo launchctl unload /System/Library/LaunchDaemons/org.cups.cupsd.plist

		# Descargar los archivos de config.
		curl -O https://soportedespe.000webhostapp.com/os-mac/file-printer/Impresora.ppd
		curl -O https://soportedespe.000webhostapp.com/os-mac/file-printer/printers.conf

		# Copia & pega los archivos de config.
		sudo cp Impresora.ppd /etc/cups/ppd/
		sudo cp printers.conf /etc/cups/

		# Genera un codigo
		newuuid=$(uuidgen)

		# Escribe el codigo en el archivo de config.
		sudo perl -i -pe "s/varuuid/$newuuid/g" /etc/cups/printers.conf

		# Dato del nombre de usuario de red
		#echo "Ingresar Username de Red: \n Example: Nombre.Apellido "
		#read var1
		
		# Escribe el nombre de usuario en el archivo printers.conf
		sudo perl -i -pe "s/usrwin/$varusr/g" /etc/cups/printers.conf

		# Cambia dueño:grupo a los archivos de config.
		sudo chown root:_lp /etc/cups/printers.conf
		sudo chown root:_lp /etc/cups/ppd/Impresora.ppd 

		# Inicia Servicio de impresion
		sudo launchctl load /System/Library/LaunchDaemons/org.cups.cupsd.plist

		# Mje al usuario
		echo ""
		echo ""
		echo "            ================================================="
		echo "            = Created by Franklin Gedler Support Team . . . ="
		echo "            ================================================="
		echo "            =            Printer Instalada . . .            ="
		echo "            =                   Ejoy =)                     ="
		echo "            ================================================="
		echo ""
		echo ""	
	fi
fi













