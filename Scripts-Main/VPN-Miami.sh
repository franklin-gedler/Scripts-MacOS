#!/bin/bash
#VPNMiamiNoBorrar

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
	echo "                  Instalando VPN MIAMI . . .                  "
	echo "=============================================================="
	ConfigVpnMiami
	curl -LO# $1
	#curl -LO https://soportedespe.000webhostapp.com/os-mac/file-vpn-miami/connstore.dat
	#curl -LO https://soportedespe.000webhostapp.com/os-mac/file-vpn-miami/S-501.dat
	installer -pkg $2 -target /
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

Install(){
	PulseCatalina="https://github.com/franklin-gedler/VPN-MacOS/releases/download/VPN-MacOS/PulseSecure-Catalina.pkg"
    PulseMojave="https://github.com/franklin-gedler/VPN-MacOS/releases/download/VPN-MacOS/PulseSecure-Mojave.pkg"
    MacVersion=$(sw_vers -productVersion | awk -F '.' '{print $1 "." $2}')
    if [[ "$MacVersion" = "10.14" ]]; then
		Vpn $PulseMojave PulseSecure-Mojave.pkg
	else
		Vpn $PulseCatalina PulseSecure-Catalina.pkg
	fi
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
    #########################################################################################
    systemsetup -settimezone America/Argentina/Buenos_Aires
	spctl --master-disable
    
	chip=$(system_profiler SPHardwareDataType | egrep -i "intel")
	if [[ "$chip" ]]; then
		# Es intel
		echo " *** Es intel ***"
		Install
	else
		# No es intel
		echo " *** Es Apple M1 ***"
		InstallRosetta
		Install
	fi

    #########################################################################################
    cat > $TEMPDIR/aux.sh << 'EOF'
	DirHost=$(cat DirHost)
	PathFile=$(egrep -r 'VPNMiamiNoBorrar' $DirHost | awk -F: 'FNR == 1 {print $1}')
	rm -rf $PathFile
EOF
	chmod +x aux.sh
	./aux.sh
	exit
fi