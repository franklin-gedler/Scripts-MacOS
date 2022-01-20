#!/bin/bash

#Prepare-MacOS.sh

NameChangeMacOS(){
	
	serial=$(ioreg -c IOPlatformExpertDevice -d 2 | awk -F\" '/IOPlatformSerialNumber/{print $(NF-1)}')
	scutil --set HostName $serial
	scutil --set LocalHostName $serial
	scutil --set ComputerName $serial
	NameComputer=$(hostname)
}

ValidatePassAdminLocalUser(){
	
	currentpass=$(osascript \
		-e 'display dialog "Password de: '$varusr'" with icon caution default answer "" with hidden answer with title "Credenciales Usuario local" buttons {"OK"}' \
		-e 'text returned of result')

	while [[ -z $currentpass ]]; do
		currentpass=$(osascript \
		-e 'display dialog "Password de: '$varusr'" with icon caution default answer "" with hidden answer with title "Credenciales Usuario local" buttons {"OK"}' \
		-e 'text returned of result')

	done
	currentpass=$(echo "$currentpass" | tr -d '[[:space:]]')

	dscl /Local/Default -authonly $varusr $currentpass
	while [[ $? -ne 0 ]]; do
		echo ""
		echo " ========================================================================= "
		echo " Problemas con credenciales de $varusr reintenta ingresar las credenciales "
		echo " ========================================================================= "
		echo ""
		#read -n 1 -s -r -p "*** Persione cualquier tecla para continuar ***"
		currentpass=$(osascript \
		-e 'display dialog "Password de: '$varusr'" with icon caution default answer "" with hidden answer with title "Credenciales Usuario local" buttons {"OK"}' \
		-e 'text returned of result')
		dscl /Local/Default -authonly $varusr $currentpass
	done
	echo ""
	echo " ************************************* "
	echo "   Credenciales de $varusr Correctas   "
	echo " ************************************* "
	echo ""
}

ConnectionAD(){
	ping -c1 IP_NameDomain &>/dev/null
	while [[ $? -ne 0 ]]; do
		echo " =========================================================================="
		echo "       Error al conectarse al Active Directory, por favor verificar!       "
		echo ""
		echo "    - Si estas desde casa, conectate a la VPN Regional"
		echo "    - Si estas en la oficina, abre otra terminal y tira un ping a NameDomain  "
		echo " =========================================================================="
		echo ""
        read -n 1 -s -r -p "*** Persione cualquier tecla para continuar ***"
        echo ""
        echo ""
        ping -c1 NameDomain &>/dev/null
	done
	echo ""
	echo " ***************************************** "
	echo "   Conexion con el AD OK, seguimos . . .   "
	echo " ***************************************** "
	echo ""
}

TestCredentialsSupport(){
    VerifyCheck=$(ldapsearch -z 0 -x -b "dc=,dc=,dc=" \
        -D "$usrSoporte@NameDomain" \
        -h IP_NameDomain \
        -w "$passSoporte" "userPrincipalName=$usrSoporte@NameDomain" | egrep "sAMAccountName=*" | cut -d' ' -f'2-')
}

InputCredentials(){
	usrSoporte=$(osascript \
		-e 'display dialog "Usuario de soporte" with icon note default answer "" with title "Credenciales Soporte" buttons {"OK"}' \
		-e 'text returned of result')

	while [[ -z $usrSoporte ]]; do
		usrSoporte=$(osascript \
		-e 'display dialog "Usuario de soporte" with icon note default answer "" with title "Credenciales Soporte" buttons {"OK"}' \
		-e 'text returned of result')
	done
	usrSoporte=$(echo "$usrSoporte" | tr -d '[[:space:]]')

	passSoporte=$(osascript \
		-e 'display dialog "Password de: '$usrSoporte'" with icon caution default answer "" with hidden answer with title "Credenciales Soporte" buttons {"OK"}' \
		-e 'text returned of result')

	while [[ -z $usrSoporte ]]; do
		passSoporte=$(osascript \
		-e 'display dialog "Password de: '$usrSoporte'" with icon caution default answer "" with hidden answer with title "Credenciales Soporte" buttons {"OK"}' \
		-e 'text returned of result')

	done
	passSoporte=$(echo "$passSoporte" | tr -d '[[:space:]]')

}

ValidateSupportCredentials(){
	
    InputCredentials
    TestCredentialsSupport

    while [[ -z "$VerifyCheck" ]]; do
        #echo "El valor de la validacion es $VerifyCheck"
        echo ""
		echo " ============================================================================= "
		echo "           Credenciales Incorrectas, por favor verificar!"
		echo ""
		echo "  - Verifica el idioma del teclado (Recordar que el teclado varia de US y ES) "
		echo "  - Reingresa tus Credenciales de RED"
		echo "  - Verifica si estas conectado a la RED empresa"
		echo " ============================================================================= "
        InputCredentials
        TestCredentialsSupport
    done
    echo ""
    echo " ***************************************** "
    echo "   Credenciales de $usrSoporte Correctas   "
    echo " ***************************************** "
    echo ""
}

BindingToAD(){

    echo ""
    echo " ========================================================== "
    echo "   Verificando si el equipo $NameComputer Existe en el AD   "
    echo " ========================================================== "
    echo ""
    ComputerInAD=$(ldapsearch -z 0 -x -b "dc=,dc=,dc=" \
        -D "$usrSoporte@NameDomain" \
        -h IP_NameDomain \
        -w "$passSoporte" "cn=$NameComputer" | egrep "distinguishedName=*" | cut -d' ' -f'2-')
    
    if [[ -z "$ComputerInAD" ]];then
        echo ""
        echo " ************************************** "
        echo "   Equipo $NameComputer NO Encontrado   "
        echo " ************************************** "
        echo ""
    else
        echo ""
        echo " ================================================================ "
        echo "   Equipo Encontrado en el AD se procede a Borrar, Espere . . .   "
        echo "     $ComputerInAD "
        echo " ================================================================ "
        echo ""
        ldapdelete -D "$usrSoporte@NameDomain" \
            -w "$passSoporte" \
            -h IP_NameDomain "$ComputerInAD"
        sleep 15
		echo ""
		echo " *********** "
		echo "   Borrado   "
		echo " *********** "
		echo ""
    fi

	echo ""
	echo " =================================  "
	echo "   Enlazando al AD, Espere . . .    "
	echo " =================================  "
	echo ""
	
	dsconfigad -add NameDomain -force -computer $NameComputer --domain DC=,DC=,DC= \
    	-username $usrSoporte -password $passSoporte -ou "OU=Computadoras,DC=,DC=,DC=" -alldomains enable -mobile enable \
    	-mobileconfirm disable -useuncpath enable

	bindingshow=$(dsconfigad -show | grep "NameDomain" | awk '{print $5}' | tr -d '[[:space:]]')
	
	while [[ "$bindingshow" != "NameDomain" ]]; do
		echo ""
		echo " ============================================================================= "
		echo "           Fallo en unir el equipo al Dominio, por favor verificar!"
		echo ""
		echo "  - Verifica el idioma del teclado (Recordar que el teclado varia de US y ES) "
		echo "  - Reingresa tus Credenciales de RED"
		echo "  - Verifica si estas conectado a la RED empresa"
		echo " ============================================================================= "
		ValidateSupportCredentials
		dsconfigad -add NameDomain -force -computer $NameComputer --domain DC=,DC=,DC= \
    		-username $usrSoporte -password $passSoporte -ou "OU=Computadoras,DC=,DC=,DC=" -alldomains enable -mobile enable \
    		-mobileconfirm disable -useuncpath enable

		bindingshow=$(dsconfigad -show | grep "NameDomain" | awk '{print $5}' | tr -d '[[:space:]]')
	done

    echo ""
	echo " **************************************************************** "
	echo "   El equipo $NameComputer se unio al Dominio AR correctamente    "
	echo " **************************************************************** "
	echo ""
	dsconfigad -passInterval 0
}

Glpi(){
	ping -c1 glpi.empresa.it &>/dev/null
	while [[ $? -ne 0 ]]; do
		echo ""
		echo " ********************************************************************************************* "
		echo "   Problemas para conectar al Server Glpi, verificar si estas conectado a la RED de empresa   "
		echo " ********************************************************************************************* "
		echo ""
		read -n 1 -s -r -p "*** Persione cualquier tecla para continuar ***"
		ping -c1 glpi.empresa.it &>/dev/null
	done
	echo ""
	echo " =============================================================="
	echo "             Instalando FusionInventory-Agent . . .            "
	echo " =============================================================="
	echo ""
	
	curl -LO# https://github.com/fusioninventory/fusioninventory-agent/releases/download/2.6/FusionInventory-Agent-2.6-2.dmg
	hdiutil attach FusionInventory-Agent-2.6-2.dmg -nobrowse 1>/dev/null
	cp -R /Volumes/FusionInventory-Agent-2.6-2/FusionInventory-Agent-2.6-2.pkg $TEMPDIR
	hdiutil detach /Volumes/FusionInventory-Agent-2.6-2/ 1>/dev/null

	# Instalando
	installer -pkg FusionInventory-Agent-2.6-2.pkg -target / -lang en

	# Config.
	Sv1="\#server \= http\:\/\/server.domain.com\/glpi\/plugins\/fusioninventory\/"
	Sv2="server \= https\:\/\/glpi.empresa.it\/plugins\/fusioninventory\/"
	perl -i -pe "s/$Sv1/$Sv2/g" /opt/fusioninventory-agent/etc/agent.cfg
	launchctl start org.fusioninventory.agent

	echo ""
	echo " ===================================================================== "
	echo "   Ejecutando por primera vez FusionInventory-Agent (Espere . . . .)   "
	echo " ===================================================================== "
	echo ""
	/opt/fusioninventory-agent/bin/fusioninventory-agent

	echo " *************** "
	echo "   Listo . . .   "
	echo " *************** "
	echo ""
}

Vpn(){
	echo ""
	echo " =============================================================="
	echo "                   Instalando VPN Regional . . .               "
	echo " =============================================================="
	echo ""
	
	Checkpoint='https://api.github.com/repos/franklin-gedler/Scripts-MacOS/releases/assets/43733382'
    NameInstaller='Endpoint_Security_VPN_E84_70.pkg'

    DownloadFileInstaller $Checkpoint
    
    installer -pkg $NameInstaller -target /
	
	launchctl unload /Library/LaunchDaemons/com.checkpoint.epc.service.plist
	cp Trac.config /Library/Application\ Support/Checkpoint/Endpoint\ Connect/
	launchctl load /Library/LaunchDaemons/com.checkpoint.epc.service.plist
	echo ""
	echo " *************** "
	echo "   Listo . . .   "
	echo " *************** "
	echo ""
	########################################################################################################
	echo ""
	echo " =============================================================="
	echo "                   Instalando VPN MIAMI . . .                  "
	echo " =============================================================="
    echo ""

	PulseSecure='https://api.github.com/repos/franklin-gedler/Scripts-MacOS/releases/assets/43733409'
    NameInstaller='PulseSecure-9_1R12.pkg'

    DownloadFileInstaller $PulseSecure
    installer -pkg $NameInstaller -target /
	
	varuuid=`cat /Library/Application\ Support/Pulse\ Secure/Pulse/DeviceId`
	ive=$(uuidgen | sed "s/-//g")
	launchctl unload /Library/LaunchDaemons/net.pulsesecure.AccessService.plist
	perl -i -pe "s/newive/$ive/g" S-501.dat
	perl -i -pe "s/varuuid/$varuuid/g" connstore.dat 
	perl -i -pe "s/newive/$ive/g" connstore.dat
	cp S-501.dat connstore.dat /Library/Application\ Support/Pulse\ Secure/Pulse/
	launchctl load /Library/LaunchDaemons/net.pulsesecure.AccessService.plist
	echo ""
	echo " *************** "
	echo "   Listo . . .   "
	echo " *************** "
	echo ""
}

DownloadFileInstaller(){
    GITHUB_API_TOKEN="Token generado por github"
    CURL_ARGS="-LJO#"
    
    curl $CURL_ARGS -H "Authorization: token $GITHUB_API_TOKEN" -H "Accept: application/octet-stream" "$1"
}

ConvertCredentialsNAS(){

    usrNAS=$usrSoporte
    passNAS=$passSoporte

    # arrays
    declare -a Characters=('\@' '\!' '\-' '\.' '\$' '\#' '\*' '\:' '\_')
	declare -a CharactersConvert=('%40' '%21' '%2D' '%2E' '%24' '%23' '%2A' '%3A' '%5F')

    for i in "${!Characters[@]}"; do

        # Nota: echo ${VARIABLE//Cadena a buscar/Cadena que reemplaza}
        usrNAS=${usrNAS//${Characters[$i]}/${CharactersConvert[$i]}}
        passNAS=${passNAS//${Characters[$i]}/${CharactersConvert[$i]}}

    done
}

AdapterPowerValidate(){
    powerstatus=$(pmset -g batt | head -n 1 | awk -F "'" '{print $2}')
        while [[ "$powerstatus" = "Battery Power" ]]; do
			echo ""
			echo " ********************************** "
			echo "   Conecte el Cargador, Por favor   "
			echo " *********************************  "
			read -n 1 -s -r -p "*** Persione cualquier tecla para continuar ***"
			powerstatus=$(pmset -g batt | head -n 1 | awk -F "'" '{print $2}')
        done

}

FileVault(){
	echo ""
	echo " ========================================= "
	echo "   Habilitando la Encriptacion Del Disco   "
	echo " ========================================= "
	echo ""
	AdapterPowerValidate
	passfilevault=$(echo "<plist>
		<dict>
		<key>Username</key>
		<string>$varusr</string>
		<key>Password</key>
		<string>$currentpass</string>
		</dict>
		</plist>" | fdesetup enable -inputplist | awk '{print $4}' | tr -d ''\')

	mkdir $TEMPDIR/folderNAS
	ConvertCredentialsNAS

	mount_smbfs "//namedomain;$usrNAS:$passNAS@IP_NAS/Carpeta_Compartida" $TEMPDIR/folderNAS
	touch $TEMPDIR/folderNAS/FileVaultMacOS/$serial.txt
	echo "$serial ; $passfilevault" > $TEMPDIR/folderNAS/FileVaultMacOS/$serial.txt
	echo "$serial ; $passfilevault" > /Users/$varusr/Desktop/$serial.txt

	diskutil unmount folderNAS &>/dev/null

	estado=$(fdesetup status)
	if [[ "$estado" = "FileVault is Off." ]]; then
		echo " ************************** "
		echo "   Filevault Unsuccessful   "
		echo " ************************** "
	else
		echo " ***************************************************************************************************** "
		echo "   Filevault Successfully, se comenzara la encriptacion progresivamente, no reiniar ni cerrar sesion   "
		echo " ***************************************************************************************************** "
	fi
	echo ""
	filevaultsendmail
}

InstallGoogleChrome(){
	
	echo ""
	echo "====================================================="
	echo "              Instalando Google Chrome"
	echo "====================================================="
	echo ""
	curl -LO# https://dl.google.com/chrome/mac/stable/GGRO/googlechrome.dmg
	hdiutil attach googlechrome.dmg -nobrowse 1>/dev/null
	cp -r /Volumes/Google\ Chrome/Google\ Chrome.app /Applications/
	hdiutil detach /Volumes/Google\ Chrome/ 1>/dev/null
	echo ""
	echo " *************** "
	echo "   Listo . . .   "
	echo " *************** "
	echo ""
}

InstallTeamViewerHost(){
	echo ""
	echo " ====================================================="
	echo "             Instalando Team Viewer Host              "
	echo " ====================================================="
	echo ""

	curl -LO# https://dl.teamviewer.com/download/version_15x/CustomDesign/TeamViewerHost-idc6gh9rc7.dmg
	hdiutil attach TeamViewerHost-idc6gh9rc7.dmg -nobrowse 1>/dev/null
	cp "/Volumes/TeamViewerHost/Install TeamViewerHost.app/Contents/Resources/Install TeamViewerHost.pkg" $TEMPDIR
	mv "Install TeamViewerHost.pkg" TeamViewerHost-idc6gh9rc7.pkg
	installer -pkg TeamViewerHost-idc6gh9rc7.pkg -target /
	hdiutil detach /Volumes/TeamViewerHost/ 1>/dev/null

	echo ""
	echo " *************** "
	echo "   Listo . . .   "
	echo " *************** "
	echo ""
}

InstallRosetta(){

	echo ""
	echo " =============================================="
	echo "              Instalando Rosetta               "
	echo " =============================================="
	echo ""

	processrosetta=$(/usr/sbin/softwareupdate --install-rosetta --agree-to-license)

	veryrosettafailed=$(echo $processrosetta | egrep -io 'Install failed with error: An error has occurred. please try again later.')
	
	#veryrosettasuccessful=$(echo $processrosetta | egrep -io 'Install of Rosetta 2 finished successfully')

	while [[ ! -z $veryrosettafailed ]]; do
		processrosetta=$(/usr/sbin/softwareupdate --install-rosetta --agree-to-license)
		veryrosettafailed=$(echo $processrosetta | egrep -io 'Install failed with error: An error has occurred. please try again later.')
	done

	echo ""
	echo " *************** "
	echo "   Listo . . .   "
	echo " *************** "
	echo ""
}

SecureAll(){

	# Enable Firewall
	#defaults write /Library/Preferences/com.apple.alf globalstate -int 1
	/usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate on

	# Permito las app que puedan recibir conexiones
	/usr/libexec/ApplicationFirewall/socketfilterfw --add /Applications/Endpoint\ Security\ VPN.app
	/usr/libexec/ApplicationFirewall/socketfilterfw --add /Applications/Pulse\ Secure.app
	#/usr/libexec/ApplicationFirewall/socketfilterfw --add /Applications/TeamViewerQS.app
	/usr/libexec/ApplicationFirewall/socketfilterfw --add /Applications/TeamViewerHost.app

}

filevaultsendmail(){

cat << EOF >> /etc/postfix/main.cf
# Postfix as relay
#Mail empresa WebMail
relayhost=mail.empresa.com:25
# Enable SASL authentication in the Postfix SMTP client.
smtp_sasl_auth_enable=yes
smtp_sasl_password_maps=hash:/etc/postfix/sasl_passwd
smtp_sasl_security_options=noanonymous
smtp_sasl_mechanism_filter=plain
# Enable Transport Layer Security (TLS), i.e. SSL.
smtp_use_tls=yes
smtp_tls_security_level=encrypt
tls_random_source=dev:/dev/urandom
EOF

	key='String encoding base64'
    key=$(echo $key | base64 --decode)

    email='String encoding base64'
    email=$(echo $email | openssl enc -base64 -d -aes-256-cbc -pass pass:$key)

    pass='String encoding base64'
    pass=$(echo $pass | openssl enc -base64 -d -aes-256-cbc -pass pass:$key)

	sed -i '' 's/inet_interfaces = loopback-only/#inet_interfaces = loopback-only/g' /etc/postfix/main.cf

	sed -i '' 's/#myorigin = $myhostname/myorigin = empresa.com/g' /etc/postfix/main.cf

	echo "mail.empresa.com:25 $email:$pass" >> /etc/postfix/sasl_passwd

	chmod 600 /etc/postfix/sasl_passwd

	postmap /etc/postfix/sasl_passwd

	echo "$passfilevault" | mail -s "$serial" soporte@empresa.com

}

PassChangeAdminLocalUser(){
	last7serial=$(echo $serial | tail -c 8 | tr -d '[[:space:]]')
	newpass="*+54#$last7serial*"
	dscl . -passwd /Users/$varusr $currentpass $newpass
}

ping -c1 google.com &>/dev/null
if [[ $? -ne 0 ]] || [[ "$EUID" != 0 ]]; then
	echo ""
	echo " ============================================================= "
	echo "   Este Script requiere sudo o no tienes conexion a internet   "
	echo " ============================================================= "
	echo ""
	exit 1
else
	DirHost=$(pwd)
	TEMPDIR=`mktemp -d`
	cd $TEMPDIR
	pwd
	echo "$DirHost" > DirHost
	#############################################################################################
	systemsetup -settimezone America/Argentina/Buenos_Aires
	sntp -sS NameDomain
	spctl --master-disable
	
	#varusr=$(who > /tmp/varusr && awk 'NR < 2 {print $1}' /tmp/varusr | tr -d '[[:space:]]')
	varusr=$(who | awk 'FNR == 1 {print $1}' | tr -d '[[:space:]]')
	idusr=$(id -u $varusr)

	
	NameChangeMacOS
	AdapterPowerValidate
	ValidatePassAdminLocalUser
	ConnectionAD
	ValidateSupportCredentials
	FileVault
	BindingToAD
	

	chip=$(system_profiler SPHardwareDataType | egrep -i "intel")
	#chip=$(/usr/sbin/sysctl -n machdep.cpu.brand_string | grep -io "Intel")
	if [[ "$chip" ]]; then
		# Es intel
		echo " *** Es intel ***"
		Glpi
		Vpn

	else
		# No es intel
		echo " *** Es Apple M1 ***"
		InstallRosetta
		Glpi
		Vpn

	fi

	InstallGoogleChrome
	InstallTeamViewerHost
	SecureAll    # Esta funcion debe de estar de ultima ya que habilito el firewall y permito la conexiones de las app instaladas
	PassChangeAdminLocalUser

	rm -rf /etc/postfix/sasl_passwd # NO Borrar
	echo ""
	echo "         =============================================== "
	echo "           Script Completado, verificar si hay errores "
	echo "         =============================================== "
	###############################################################################################
	cat > $TEMPDIR/aux.sh << 'EOF'
	DirHost=$(cat DirHost)
	PathFile=$(egrep -r 'Prepare-MacOS.sh' $DirHost | awk -F: 'FNR == 1 {print $1}')
	rm -rf $PathFile
EOF
	chmod +x aux.sh
	./aux.sh
	exit
fi