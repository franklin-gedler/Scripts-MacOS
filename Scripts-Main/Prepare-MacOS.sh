#!/bin/bash

#Prepare-MacOS.sh

NameChangeMacOS(){
	# Setea nombre del equipo
	#prefix="AR"
	#serial=`system_profiler SPHardwareDataType | awk '/Serial Number/ { print $4 }'`
	#scutil --set ComputerName "${prefix}${serial}"
	#scutil --set HostName "${prefix}${serial}"
	#scutil --set LocalHostName "${prefix}${serial}"
	
	serial=$(ioreg -c IOPlatformExpertDevice -d 2 | awk -F\" '/IOPlatformSerialNumber/{print $(NF-1)}')
	scutil --set HostName AR$serial
	scutil --set LocalHostName AR$serial
	scutil --set ComputerName AR$serial
}

SupportCredentials(){
	# Credenciales del chico de soporte
	#usrSoporte=$(osascript -e 'Tell application "System Events" to display dialog "Ingresar un Usuario de Soporte:" default answer ""' -e 'text returned of result' 2>/dev/null)
	usrSoporte=$(osascript -e 'Tell application "System Events" to display dialog "Usuario de Soporte:" default answer "Nombre.Apellido" buttons {"OK"}' -e 'text returned of result' 2>/dev/null)
	passSoporte=$(osascript -e 'Tell application "System Events" to display dialog "Password de '$usrSoporte':" with hidden answer default answer "" buttons {"OK"}' -e 'text returned of result' 2>/dev/null)
}

SetPass(){
	currentpass=$(osascript -e 'Tell application "System Events" to display dialog "Password De: '$varusr'" with hidden answer default answer "" buttons {"OK"}' -e 'text returned of result' 2>/dev/null | tr -d '[[:space:]]')
	dscl /Local/Default -authonly $varusr $currentpass
	while [[ $? -ne 0 ]]; do
		echo ""
		echo " ========================================================================= "
		echo " Problemas con credenciales de $varusr reintenta ingresar las credenciales "
		echo " ========================================================================= "
		#read -n 1 -s -r -p "*** Persione cualquier tecla para continuar ***"
		currentpass=$(osascript -e 'Tell application "System Events" to display dialog "Error!! Reingrese Contraseña de: '$varusr'" with hidden answer default answer "" buttons {"OK"}' -e 'text returned of result' 2>/dev/null | tr -d '[[:space:]]')
		dscl /Local/Default -authonly $varusr $currentpass
	done
	echo ""
	echo " ================================= "
	echo " Credenciales de $varusr Correctas "
	echo " ================================= "
	echo ""
	last7serial=$(echo $serial | tail -c 8 | tr -d '[[:space:]]')
	newpass="*+54#$last7serial*"
	dscl . -passwd /Users/admindesp $currentpass $newpass
}

BindingToAD(){
	echo ""
	echo " Enlazando al AD, Espere . . ."
	echo ""
	NameComputer=$(hostname)
	dsconfigad -add ar.infra.d -force -computer $NameComputer --domain DC=AR,DC=INFRA,DC=D -username $usrSoporte -password $passSoporte -alldomains enable -mobile enable -mobileconfirm disable -useuncpath enable
	echo "-----------------------------------------------------------------------"
	bindingshow=$(dsconfigad -show | grep "ar.infra.d" | awk '{print $5}' | tr -d '[[:space:]]')
	
	while [[ "$bindingshow" != "ar.infra.d" ]]; do
		echo ""
		echo " ============================================================================= "
		echo "           Fallo en unir el equipo al Dominio, por favor verificar!"
		echo ""
		echo "  - Verifica el idioma del teclado (Recordar que el teclado varia de US y ES) "
		echo "  - Reingresa tus Credenciales de RED"
		echo "  - Verifica si estas conectado a la RED Despegar"
		echo " ============================================================================= "
		SupportCredentials
		dsconfigad -add ar.infra.d -force -computer $NameComputer --domain DC=AR,DC=INFRA,DC=D -username $usrSoporte -password $passSoporte -alldomains enable -mobile enable -mobileconfirm disable -useuncpath enable
		bindingshow=$(dsconfigad -show | grep "ar.infra.d" | awk '{print $5}' | tr -d '[[:space:]]')
	done

	echo " =========================================================== "
	echo " El equipo $NameComputer se unio al Dominio AR correctamente "
	echo " =========================================================== "
	echo ""
}

Glpi(){
	ping -c1 glpi.despegar.it &>/dev/null
	while [[ $? -ne 0 ]]; do
	echo ""
	echo "-----------------------------------------------------------------------------------------------"
	echo "|* Problemas para conectar al Server Glpi, verificar si estas conectado a la RED de Despegar *|"
	echo "-----------------------------------------------------------------------------------------------"
	read -n 1 -s -r -p "*** Persione cualquier tecla para continuar ***"
	ping -c1 glpi.despegar.it &>/dev/null
	done
	echo ""
	echo "=============================================================="
	echo "            Instalando FusionInventory-Agent . . .            "
	echo "=============================================================="
	curl -LO https://github.com/fusioninventory/fusioninventory-agent/releases/download/2.5.2/FusionInventory-Agent-2.5.2-1.dmg
	hdiutil attach FusionInventory-Agent-2.5.2-1.dmg -nobrowse 1>/dev/null
	cp -R /Volumes/FusionInventory-Agent-2.5.2-1/FusionInventory-Agent-2.5.2-1.pkg $TEMPDIR
	hdiutil detach /Volumes/FusionInventory-Agent-2.5.2-1/

	# Instalando
	installer -pkg FusionInventory-Agent-2.5.2-1.pkg -target / -lang en

	# Config.
	Sv1="\#server \= http\:\/\/server.domain.com\/glpi\/plugins\/fusioninventory\/"
	Sv2="server \= https\:\/\/glpi.despegar.it\/plugins\/fusioninventory\/"
	perl -i -pe "s/$Sv1/$Sv2/g" /opt/fusioninventory-agent/etc/agent.cfg
	launchctl start org.fusioninventory.agent

	echo ""
	echo "==========================================================================="
	echo "     Ejecutando por primera vez FusionInventory-Agent (Espere . . . .)     "
	echo "==========================================================================="
	/opt/fusioninventory-agent/bin/fusioninventory-agent
}

ConfigVpnRegional(){
cat > $TEMPDIR/Trac.config << 'EOF'
TRAC2c2e62637c7a72777c737b637e60711f033f2b0162647779100f04095e7b170d60101779647d0e7b7517746565420d1415ff04ff606e0e7552212b673428232a5d4051470b5843025044585252547f5f49564d52071451464c437057465641425e106c657e7e63180974656568134f76666e7c1d0b047806037968137974587b721d1763020479372c353c641d6860611f050a28250162726c6279476b03090e132f1766777665707f7f6d730e031001040c350d6968060415670f7b6a5059403f273a56246820255237263736256d6f54384e30202419272b265952574a514447474b45561f7a67426d7c090e13050914122f0e6273627e650e030e035049511d56483320353b562166464a022720265a31372a3b563a3733676d2a3f513952372a21193e236f607266627516020f1f10171f3d185d6d7e747e1c191716021c1e19041e09041311ff18150e0241404d35352c17572b38420b620906086768656568137974587b1d0eff710709787b6b322c2a615f5253465559474b1142561258527f4149474140404a5753070d4a5f51516a585e5c5157455b13696806041574136568140b0f426a0476060415670f6776627c7e79641e6117766b797f7866725f57504255437d5858107a7e656740100c150e1305093e0c77757c676f727a73790c01040c1f391a7e131a0807610367080b0f68744309190417096376686c67617f6606631e71737c776b792a405a407c51494741515f54605e56714559565d1368686673750c0f12101f1501350e6c657e7e630b156a677430036775404e5c17272c452131242d55062335651d0eff71071a64656966696445137e7571647a0d130112070f02123211584741437a5d465d55434153424b6a554b514f04617e616579686565681365683e1562090608677b797b6aff6d607078243d3d400852362a393527253d596c4053465e02627e62766f0b06300c0c150e391b6475606460ff0e0e1d57405c1e43415b4c504d0627312b2d5d2a3859444c67070a7e7b363126563038316a72723e422279212128342e343a7240574a0567637d7e600b1f1706300c0c3f107e647b75620a0c1110ff061b17091e17151e11031d187678372c5724385d744b26243f17190417096365747265706f723a696b051708166678710f4151505075495c5e120a5a53497d7349514f414259416d4a5541127d7e67606f0c01040c1f1304236a08041a72156708150d6a692d523827242656063a3d2c242c374432421b3126363a3020451316465058560d0255535654437473585b4b5a494a147f64626e620c1f15011f10012e1272727668046a797611ff067b0b611f15697906040768700d117207110310101f72010769110c16080d76706a640a6d66777f177176695a0c64667b71057d7773631212465e5647514d55464a45596c474a37650809610418080b0f687469175e7b08096118047d796e6d6404671772737f777175620f0e58425358475b5159685a5a4f647358564b5d4b46576d51434e5e107274737e601d040c1f1304095e7b08096104181b17116a3628547a3626216c35377d362421375e3856292a2a691a07060240404d40434e4c10120a5345534f4e4d5671404640147f64626e620c1f15011f10012e1272727668046a797611262d677b666a692c472d311a265d36377208111d13606b0664656966694e716072666275051e111d44545a4343540143415b72071440404a405c5c514d4101727173657c03130409746565420d0809666a7f6768771566777578036961617d72723c5f3e5536203f193d2a2a445f5703686b706e6f0c171f1706300c260b63727768641d190e0d1d7c7370696c730e0611534151763121243a54353d6b484e3a20697a151704180f79747265706f580e1a6716041969757a6d484646570717464a5352565152796442495c42500564756064601312101f15011f3a1f696d6d727406687b6771037578041b1c716d6b0a3a2a2c3b413c220d27312c0d43344f640808140814730d131403050a28117271657e67092c120e62616564097f716a740f77786c15666a71016d607a1360671b0365ff601005146f6e0d0669731b17116876ff0672121f01727d1263ff677432272d3d5d4151444b4344705e53685356486249585b471368686673750c0f12101f1501350e6c657e7e630b156a67202c5a262d50745b2631205b3767782c5c312037280f213d592347272c3d282c2c3b58526b57495f43495a5417727674517c10150e13050914381b7d6e60716f1a1d011218151c0d1315196e757772017768ff1a0f2f2108173020126a0e3c393b310f3b315539482b2616323a25230d7e7571647a1e0f1f10171f172c2e616d676f630a150a1015ff1f04ff0f06110b121c5649496c574c332428216c362b5d0b620906086768656568137974587b1d0eff710709787b6b353d2a2a435c444e4a490d7c7c79184c4348754540560111184546477a555c535260464256106c657e7e63180974656568134f76796a7d0904660b6a672729507727372231223b6f04650d6a3a322721214243594c4605716c761f444b594379404f1a0c0e495b416d565548535d566a525c5901696d6d727415746565681365420a666e1a151918687b672d40353534676d3c315908483137690b08160e7d0f1403050a020f350e7a7e65674003100b0c776c767a7d6c637c7763607b71697371670e025649483a1a2021582a27570b620906086768656568137974587b1d0eff710709787b6b322c2a615f5253465559474b111a150259454f5e49435c565609797377717f0e101f15011f102b1a617e6165797b797b6a037578021b1f7b647d156937203e6c2a373b651d0eff71071a64656966696445137e7571647a0d130112524c5b47760e11504a5c487657507a4748127d7e67606f0c01040c1f1304236a08041a72156708150d786478156937203e6c353b312a24202040084928292c2e69090e7f72641f050a020f1f103d017a67426d7c1a120d070640404053ff414451504853530e0611534151763131242b5a232140594a2b74047606041574137974726570456c671079090a1bff75646f0d133e1d0778677c6a120a4d5255650c0e414b5d0b5b555540405c5754114740125f554b415a414b5a3126262911783f530b7d0d071c680302796813535e6c0b1f0606710573030c0f0806077327
EOF
}

ConfigVpnMiami(){
cat > $TEMPDIR/connstore.dat << 'EOF'
;
; /Library/Application Support/Pulse Secure/Pulse/connstore.dat
; Sat Aug 10 00:21:26 2019
;

ive "newive" {
  connection-source: "user"
  friendly-name: "VPN MIAMI"
  uri: "https://newton.despegar.net/IT"
}

machine "local" {
  guid: "varuuid"
  pulse-language: "es"
}

schema "version" {
  version: "1"
}
EOF

cat > $TEMPDIR/S-501.dat << 'EOF'
;
; /Library/Application Support/Pulse Secure/Pulse/S-501.dat
; Sat Aug 10 00:21:26 2019
;

ive "newive" {
  control>_transient: "restart"
  control>connect: "0"
}

schema "version" {
  control>version: "1"
}
EOF
}


Vpn(){
	echo ""
	echo "=============================================================="
	echo "                  Instalando VPN Regional . . .               "
	echo "=============================================================="
	ConfigVpnRegional
	curl -LO $1
	installer -pkg $2 -target /
	launchctl unload /Library/LaunchDaemons/com.checkpoint.epc.service.plist
	#newuuid=$(uuidgen)
	#perl -i -pe "s/varuuid/$newuuid/g" LangPack1.xml
	#cp LangPack1.xml Trac.* /Library/Application\ Support/Checkpoint/Endpoint\ Connect/
	cp Trac.config /Library/Application\ Support/Checkpoint/Endpoint\ Connect/
	launchctl load /Library/LaunchDaemons/com.checkpoint.epc.service.plist
	echo ""
	echo "Listo . . ."
	echo ""
	########################################################################################################
	echo ""
	echo "=============================================================="
	echo "                  Instalando VPN MIAMI . . .                  "
	echo "=============================================================="
	ConfigVpnMiami
	curl -LO $3
	#curl -LO https://soportedespe.000webhostapp.com/os-mac/file-vpn-miami/connstore.dat
	#curl -LO https://soportedespe.000webhostapp.com/os-mac/file-vpn-miami/S-501.dat
	installer -pkg $4 -target /
	varuuid=`cat /Library/Application\ Support/Pulse\ Secure/Pulse/DeviceId`
	ive=$(uuidgen | sed "s/-//g")
	launchctl unload /Library/LaunchDaemons/net.pulsesecure.AccessService.plist
	perl -i -pe "s/newive/$ive/g" S-501.dat
	perl -i -pe "s/varuuid/$varuuid/g" connstore.dat 
	perl -i -pe "s/newive/$ive/g" connstore.dat
	cp S-501.dat connstore.dat /Library/Application\ Support/Pulse\ Secure/Pulse/
	launchctl load /Library/LaunchDaemons/net.pulsesecure.AccessService.plist
	echo ""
	echo "Listo . . ."
	echo ""
}

FileVault(){
	echo ""
	#passusr=$(osascript -e 'Tell application "System Events" to display dialog "Ingresar Password De: '$varusr'" with hidden answer default answer ""' -e 'text returned of result' 2>/dev/null | tr -d '[[:space:]]')
	#curl -LO https://soportedespe.000webhostapp.com/os-mac/FileVaultOn/g 2> /tmp/null && g=$(cat g)
	#serial=$(ioreg -c IOPlatformExpertDevice -d 2 | awk -F\" '/IOPlatformSerialNumber/{print $(NF-1)}')
	echo "Configurando la encriptacion . . ."
	passfilevault=$(echo "<plist>
		<dict>
		<key>Username</key>
		<string>$varusr</string>
		<key>Password</key>
		<string>$newpass</string>
		</dict>
		</plist>" | fdesetup enable -inputplist | awk '{print $4}' | tr -d ''\')
	mkdir $TEMPDIR/dirtemp
	mount_smbfs "//AR.INFRA.D;$usrSoporte:$passSoporte@10.40.54.52/soporte" $TEMPDIR/dirtemp
	echo "$serial ; $passfilevault" >> $TEMPDIR/dirtemp/Encryption-MacOS.txt
	echo "$serial ; $passfilevault" > /Users/admindesp/Desktop/$serial.txt
	umount $TEMPDIR/dirtemp
	estado=$(fdesetup status)
	if [[ "$estado" = "FileVault is Off." ]]; then
		echo "======================"
		echo "Filevault Unsuccessful"
		echo "======================"
	else
		echo "==============================================================================================="
		echo "Filevault Successfully, se comenzara la encriptacion progresivamente, no reiniar ni cerrar sesion"
		echo "==============================================================================================="
	fi
	echo ""
}

InstallGoogleChrome(){
	echo ""
	echo "====================================================="
	echo "              Descargando Google Chrome"
	echo "====================================================="
	curl -LO https://dl.google.com/chrome/mac/stable/GGRO/googlechrome.dmg
	echo ""

	echo "====================================================="
	echo "              Instalando Google Chrome"
	echo "====================================================="
	hdiutil attach googlechrome.dmg -nobrowse 1>/dev/null
	cp -r /Volumes/Google\ Chrome/Google\ Chrome.app /Applications/
	hdiutil detach /Volumes/Google\ Chrome/
	echo ""
	echo "Listo . . ."
	echo ""

}

ping -c1 google.com &>/dev/null
if [[ $? -ne 0 ]] || [[ "$EUID" != 0 ]]; then
	echo "========================================================="
	echo "Este Script requiere sudo o no tienes conexion a internet"
	echo "========================================================="
	exit 1
else
	DirHost=$(pwd)
	TEMPDIR=`mktemp -d`
	cd $TEMPDIR
	pwd
	echo "$DirHost" > DirHost
	#############################################################################################
	systemsetup -settimezone America/Argentina/Buenos_Aires
	sntp -sS ar.infra.d
	spctl --master-disable

	#varusr=$(who > /tmp/varusr && awk 'NR < 2 {print $1}' /tmp/varusr | tr -d '[[:space:]]')
	varusr=$(who | awk 'FNR == 1 {print $1}' | tr -d '[[:space:]]')
	idusr=$(id -u $varusr)

	NameChangeMacOS
	SetPass
	CheckpointCatalina="https://github.com/franklin-gedler/VPN-MacOS/releases/download/VPN-MacOS/Endpoint_Security_VPN_E82-Catalina.pkg"
	PulseCatalina="https://github.com/franklin-gedler/VPN-MacOS/releases/download/VPN-MacOS/PulseSecure-Catalina.pkg"
	#########################################################################################################
	CheckpointMojave="https://github.com/franklin-gedler/VPN-MacOS/releases/download/VPN-MacOS/Endpoint_Security_VPN_E80.71-Mojave.pkg"
	PulseMojave="https://github.com/franklin-gedler/VPN-MacOS/releases/download/VPN-MacOS/PulseSecure-Mojave.pkg"
	MacVersion=$(sw_vers -productVersion | awk -F '.' '{print $1 "." $2}')
	if [[ "$MacVersion" = "10.14" ]]; then
		Vpn $CheckpointMojave Endpoint_Security_VPN_E80.71-Mojave.pkg $PulseMojave PulseSecure-Mojave.pkg
	else
		Vpn $CheckpointCatalina Endpoint_Security_VPN_E82-Catalina.pkg $PulseCatalina PulseSecure-Catalina.pkg
	fi
	SupportCredentials
	BindingToAD
	InstallGoogleChrome
	FileVault
	Glpi
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

