#!/bin/bash
EncryptionBindingAD(){
	varusr=$(who > /tmp/varusr && awk 'NR < 2 {print $1}' /tmp/varusr | tr -d '[[:space:]]')
	idusr=$(id -u $varusr)
	serial=$(ioreg -c IOPlatformExpertDevice -d 2 | awk -F\" '/IOPlatformSerialNumber/{print $(NF-1)}')
	passusr=$(osascript -e 'Tell application "System Events" to display dialog "Ingresar Password Para: '$varusr'" with hidden answer default answer ""' -e 'text returned of result' 2>/dev/null | tr -d '[[:space:]]')
	sysadminctl -adminUser admindesp -adminPassword *Gr4lPeron1710-18:55* -secureTokenOn $varusr -password $passusr
	echo "Configurando la encriptacion . . ."
	passfilevault=$(echo "<plist>
		<dict>
		<key>Username</key>
		<string>$varusr</string>
		<key>Password</key>
		<string>$passusr</string>
		<key>AdditionalUsers</key>
		<array>
			<dict>
				<key>Username</key>
				<string>admindesp</string>
				<key>Password</key>
				<string>*Gr4lPeron1710-18:55*</string>
			</dict>
		</array>
		</dict>
		</plist>" | fdesetup enable -inputplist | awk '{print $4}' | tr -d ''\')
	#dseditgroup -u $USER -P $passusr -o edit -a $USER -t user wheel
	mkdir $TEMPDIR/dirtemp
	# Viejo NAS------------------------------------------------------------------------
	#mount -t smbfs //soporte:Fantasma23*@10.254.112.31/Software/MacOS $TEMPDIR/dirtemp
	#----------------------------------------------------------------------------------
	mount_smbfs "//AR.INFRA.D;franklin.gedler:Sabrina-Stella-1801.-.@10.40.54.52/soporte" $TEMPDIR/dirtemp
	echo "$serial ; $passfilevault ; $USER" >> $TEMPDIR/dirtemp/Encryption-MacOS.txt
	#diskutil unmount $TEMPDIR/dirtemp 2>&1
	umount $TEMPDIR/dirtemp
	estado=$(fdesetup status)
	if [[ "$estado" = "FileVault is Off." ]]; then
		echo "==================================="
		echo "Fallo, Por favor pasar por Soporte "
		echo "==================================="
	else
		echo "==============================================================================================="
		echo "Finalizado con exito, se comenzara la encriptacion progresivamente, no reiniar ni cerrar sesion"
		echo "==============================================================================================="
	fi
}

EncryptionNOTBindingAD(){
	serial=$(ioreg -c IOPlatformExpertDevice -d 2 | awk -F\" '/IOPlatformSerialNumber/{print $(NF-1)}')
	passusr=$(osascript -e 'Tell application "System Events" to display dialog "Ingresar Password Para: '$USER'" with hidden answer default answer ""' -e 'text returned of result' 2>/dev/null | tr -d '[[:space:]]')
	echo "Configurando la encriptacion . . ."
	passfilevault=$(echo "<plist>
		<dict>
		<key>Username</key>
		<string>$USER</string>
		<key>Password</key>
		<string>$passusr</string>
		</dict>
		</plist>" | fdesetup enable -inputplist | awk '{print $4}' | tr -d ''\')
	mkdir $TEMPDIR/dirtemp
	# Viejo NAS------------------------------------------------------------------------
	#mount -t smbfs //soporte:Fantasma23*@10.254.112.31/Software/MacOS $TEMPDIR/dirtemp
	#----------------------------------------------------------------------------------
	mount_smbfs "//AR.INFRA.D;franklin.gedler:Sabrina-Stella-1801.-.@10.40.54.52/soporte" $TEMPDIR/dirtemp
	echo "$serial ; $passfilevault ; $USER ; ¡Equipo no esta en Dominio!" >> $TEMPDIR/dirtemp/Encryption-MacOS.txt
	#diskutil unmount $TEMPDIR/dirtemp 2>&1
	umount $TEMPDIR/dirtemp
	estado=$(fdesetup status)
	if [[ "$estado" = "FileVault is Off." ]]; then
		echo "==================================="
		echo "Fallo, Por favor pasar por Soporte "
		echo "==================================="
	else
		echo "==============================================================================================="
		echo "Finalizado con exito, se comenzara la encriptacion progresivamente, no reiniar ni cerrar sesion"
		echo "==============================================================================================="
	fi
}


ping -c1 google.com &>/dev/null
if [[ $? -ne 0 ]] || [[ "$EUID" != 0 ]]; then
	echo "========================================================="
	echo "Este Script requiere root o no tienes conexion a internet"
	echo "========================================================="
	exit 1
else
	bindingshow=$(dsconfigad -show | grep "ar.infra.d" | awk '{print $5}' | tr -d '[[:space:]]')
	if [[ "$bindingshow" = "ar.infra.d" ]]; then
		EncryptionBindingAD
	else
		echo "========================="
		echo "Equipo no esta en Dominio"
		echo "========================="
		EncryptionNOTBindingAD
	fi
fi