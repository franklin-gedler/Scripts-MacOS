#!/bin/bash





ping -c1 google.com &>/dev/null
if [[ $? -ne 0 ]] || [[ "$EUID" != 0 ]]; then
	echo "Este Script requiere sudo o no tienes conexion a internet"
	exit 1
else
	TEMPDIR=$(mktemp -d)
	cd $TEMPDIR

	# Este instalador es el de Despegar
	echo "Instalando TeamViewerHost"
	curl -LO https://github.com/franklin-gedler/Only-Download/releases/download/TVH/TVH-idc6gh9rc7.pkg
	installer -pkg TVH-idc6gh9rc7.pkg -target /
	
#	curl -LO https://download.teamviewer.com/download/TeamViewerHost.dmg
#	hdiutil attach TeamViewerHost.dmg -nobrowse 1>/dev/null
#	cp -R /Volumes/TeamViewerHost/Install\ TeamViewerHost.pkg $TEMPDIR
#	hdiutil detach /Volumes/TeamViewerHost/
#	echo "Instalando TeamViewerHost"
#	installer -pkg Install\ TeamViewerHost.pkg -target /
	echo "Listo"
fi