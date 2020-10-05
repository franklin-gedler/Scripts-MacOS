#!/bin/bash
#EBSMacOSNoBorrar

ping -c1 google.com &>/dev/null
if [[ $? -ne 0 ]] || [[ "$EUID" != 0 ]]; then
	echo "========================================================="
	echo "Este Script requiere sudo o no tienes conexion a internet"
	echo "========================================================="
	exit 1
else
	varusr=$(who | awk 'FNR == 1 {print $1}' | tr -d '[[:space:]]')
	idusr=$(id -u $varusr)
	DirHost=$(pwd)
	TEMPDIR=`mktemp -d`
	cd $TEMPDIR
	pwd
	echo "$DirHost" > DirHost
	###########################################################################################################

	# Nota: Para que ande el Java en firefox es necesario usar la version de firefox "esr" por ende por las dudas
	# el .dmg se almacena en github para que siempre este disponible.

	# Downloads
	curl -LO https://github.com/franklin-gedler-despegar/EBSMacOS/releases/download/1/Firefox52.0esr.dmg
	#curl -LO https://ftp.mozilla.org/pub/firefox/releases/52.0esr/mac/en-US/Firefox%2052.0esr.dmg
	curl -LO https://github.com/franklin-gedler-despegar/EBSMacOS/releases/download/1/jre-8u261-macosx-x64.dmg
	curl -LO https://github.com/franklin-gedler-despegar/EBSMacOS/releases/download/1/Firefox.zip
	curl -LO https://github.com/franklin-gedler-despegar/EBSMacOS/releases/download/1/Oracle.zip

	# ---------- Instalando Firefox --------------
	hdiutil attach -nobrowse Firefox52.0esr.dmg 1>/dev/null
	cp -R /Volumes/Firefox/Firefox.app /Users/$varusr/Desktop/EBS-ORACLE.app
	chmod -R 777 /Users/$varusr/Desktop/EBS-ORACLE.app
	chown -R $idusr: /Users/$varusr/Desktop/EBS-ORACLE.app
	unzip Firefox.zip 1>/dev/null
	cp -R Firefox /Users/$varusr/Library/Application\ Support/
	chmod -R 777 /Users/$varusr/Library/Application\ Support/Firefox
	chown -R $idusr: /Users/$varusr/Library/Application\ Support/Firefox
	hdiutil detach /Volumes/Firefox/

	# ---------- Instalando y config Java --------------
	hdiutil attach -nobrowse jre-8u261-macosx-x64.dmg 1>/dev/null
	cp -R /Volumes/Java\ 8\ Update\ 261/Java\ 8\ Update\ 261.app $TEMPDIR
	./Java\ 8\ Update\ 261.app/Contents/MacOS/MacJREInstaller 1>/dev/null && echo "Java instalado"
	hdiutil detach /Volumes/Java\ 8\ Update\ 261
	
	unzip Oracle.zip 1>/dev/null
	cp -R Oracle /Users/$varusr/Library/Application\ Support
	chown -R $idusr: /Users/$varusr/Library/Application\ Support/Oracle

	# ------------- Ejecuto el firefox ----------------
	open /Users/$varusr/Desktop/EBS-ORACLE.app

	######################################################################################################
	cat > $TEMPDIR/aux.sh << 'EOF'
	DirHost=$(cat DirHost)
	PathFile=$(egrep -r 'EBSMacOSNoBorrar' $DirHost | awk -F: 'FNR == 1 {print $1}')
	rm -rf $PathFile
EOF
	chmod +x aux.sh
	./aux.sh
	exit
fi