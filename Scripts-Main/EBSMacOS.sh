#!/bin/bash
#EBSMacOSNoBorrar

DownloadFiles(){

    # Variables que puedes tocar
    name="$1"
    GITHUB_API_TOKEN="523f44174360fffe6217d72c77aa03a32f157179"
    owner="franklin-gedler-despegar"
    repo="EBSMacOS"
    tag="1"

    # Variables que no se tocan
    GH_API="https://api.github.com"
    GH_REPO="$GH_API/repos/$owner/$repo"
    GH_TAGS="$GH_REPO/releases/tags/$tag"
    AUTH="Authorization: token $GITHUB_API_TOKEN"
    CURL_ARGS="-LJO#"

    response=$(curl -sH "$AUTH" $GH_TAGS)
    eval $(echo "$response" | grep -C3 "name.:.\+$name" | grep -w id | tr : = | tr -cd '[[:alnum:]]=')
    #[ "$id" ] || { echo "Error: Failed to get asset id, response: $response" | awk 'length($0)<100' >&2; exit 1; }
    GH_ASSET="$GH_REPO/releases/assets/$id"
    #echo "$GH_ASSET"

    # Download asset file.
    #echo "Downloading asset..." >&2
    #curl $CURL_ARGS -H 'Accept: application/octet-stream' "$GH_ASSET?access_token=$GITHUB_API_TOKEN"
	curl $CURL_ARGS -H "Authorization: token $GITHUB_API_TOKEN" -H "Accept: application/octet-stream" "$GH_ASSET"
    #echo "$0 done." >&2
}

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

    echo " ============================= "
    echo "        Downloading . . .      "
    echo " ============================= "
    echo ""

    DownloadFiles Firefox52.0esr.dmg
    DownloadFiles jre-8u261-macosx-x64.dmg
    DownloadFiles Firefox.zip
    DownloadFiles Oracle.zip

	# Downloads old
	#curl -LO https://github.com/franklin-gedler-despegar/EBSMacOS/releases/download/1/Firefox52.0esr.dmg
	#curl -LO https://ftp.mozilla.org/pub/firefox/releases/52.0esr/mac/en-US/Firefox%2052.0esr.dmg
	#curl -LO https://github.com/franklin-gedler-despegar/EBSMacOS/releases/download/1/jre-8u261-macosx-x64.dmg
	#curl -LO https://github.com/franklin-gedler-despegar/EBSMacOS/releases/download/1/Firefox.zip
	#curl -LO https://github.com/franklin-gedler-despegar/EBSMacOS/releases/download/1/Oracle.zip

	# verificar si esta instalado el java y el firefox y borre
	# PATH JAVA puede que este en /Library/Java/
	# PATH JAVA /Users/$varusr/Library/Application\ Support/Oracle
	# PATH firefox /Users/$varusr/Library/Application\ Support/Firefox
	rm -rf /Library/Java
	rm -rf /Users/$varusr/Library/Application\ Support/Oracle
	rm -rf /Users/$varusr/Library/Application\ Support/Firefox

    echo ""
    echo " ============================= "
    echo "        Instalando . . .       "
    echo " ============================= "
    echo ""

	# ---------- Instalando Firefox --------------
	hdiutil attach -nobrowse Firefox52.0esr.dmg 1>/dev/null
	cp -R /Volumes/Firefox/Firefox.app /Users/$varusr/Desktop/EBS-ORACLE.app
	chmod -R 777 /Users/$varusr/Desktop/EBS-ORACLE.app
	chown -R $idusr: /Users/$varusr/Desktop/EBS-ORACLE.app
	unzip Firefox.zip 1>/dev/null
	cp -R Firefox /Users/$varusr/Library/Application\ Support/
	chmod -R 777 /Users/$varusr/Library/Application\ Support/Firefox
	chown -R $idusr: /Users/$varusr/Library/Application\ Support/Firefox
	hdiutil detach /Volumes/Firefox/ 1>/dev/null
    echo " FireFox Instalado "

	# ---------- Instalando y config Java --------------
	hdiutil attach -nobrowse jre-8u261-macosx-x64.dmg 1>/dev/null
	cp -R /Volumes/Java\ 8\ Update\ 261/Java\ 8\ Update\ 261.app $TEMPDIR
	./Java\ 8\ Update\ 261.app/Contents/MacOS/MacJREInstaller 2>/dev/null && echo " Java Instalado "
	hdiutil detach /Volumes/Java\ 8\ Update\ 261 1>/dev/null
	
	unzip Oracle.zip 1>/dev/null
	cp -R Oracle /Users/$varusr/Library/Application\ Support
	chown -R $idusr: /Users/$varusr/Library/Application\ Support/Oracle

	# ------------- Ejecuto el firefox ----------------
	open /Users/$varusr/Desktop/EBS-ORACLE.app
	echo ""
    echo " Script Finalizado "
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