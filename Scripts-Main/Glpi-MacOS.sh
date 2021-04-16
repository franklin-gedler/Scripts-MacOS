#!/bin/bash
#GlpiNoBorrar

ping -c1 glpi.despegar.it &>/dev/null
if [[ $? -ne 0 ]] || [[ "$EUID" != 0 ]]; then
	echo " ====================================================================="
	echo "  Este Script requiere sudo o no estas conectado a la RED de Despegar "
	echo " ====================================================================="
	exit 1
else
	DirHost=$(pwd)
	TEMPDIR=`mktemp -d`
	cd $TEMPDIR
	pwd
	echo "$DirHost" > DirHost
	################################################################################################
	systemsetup -settimezone America/Argentina/Buenos_Aires
	spctl --master-disable

	#otra forma de montar --------------------------------------
	#hdiutil mount FusionInventory-Agent-2.5.2-1.dmg -nobrowse
	#hdiutil unmount FusionInventory-Agent-2.5.2-1.dmg
	#-----------------------------------------------------------

	echo " ============================= "
    echo "        Downloading . . .      "
    echo " ============================= "
    echo ""
	
	curl -LO# https://github.com/fusioninventory/fusioninventory-agent/releases/download/2.6/FusionInventory-Agent-2.6-2.dmg
	hdiutil attach FusionInventory-Agent-2.6-2.dmg -nobrowse 1>/dev/null
	cp -R /Volumes/FusionInventory-Agent-2.6-2/FusionInventory-Agent-2.6-2.pkg $TEMPDIR
	hdiutil detach /Volumes/FusionInventory-Agent-2.6-2/ 1>/dev/null

	#curl -LO# https://github.com/fusioninventory/fusioninventory-agent/releases/download/2.5.2/FusionInventory-Agent-2.5.2-1.dmg
	#hdiutil attach FusionInventory-Agent-2.5.2-1.dmg -nobrowse 1>/dev/null
	#cp -R /Volumes/FusionInventory-Agent-2.5.2-1/FusionInventory-Agent-2.5.2-1.pkg $TEMPDIR
	#hdiutil detach /Volumes/FusionInventory-Agent-2.5.2-1/ 1>/dev/null

	# Instalando
	echo " ======================================== "
	echo "             Instalando . . .             "
	echo " ======================================== "

	installer -pkg FusionInventory-Agent-2.6-2.pkg -target / -lang en
	#installer -pkg FusionInventory-Agent-2.5.2-1.pkg -target / -lang en

	#-------------------------------------------------------------
	# PATH del fusion /opt/fusioninventory-agent/
	#-------------------------------------------------------------

	# Config.
	Sv1="\#server \= http\:\/\/server.domain.com\/glpi\/plugins\/fusioninventory\/"
	Sv2="server \= https\:\/\/glpi.despegar.it\/plugins\/fusioninventory\/"
	perl -i -pe "s/$Sv1/$Sv2/g" /opt/fusioninventory-agent/etc/agent.cfg
	launchctl start org.fusioninventory.agent

	echo ""
	echo " =========================================================== "
	echo "   Ejecutando por primera vez . . . (Espere . . . .)         "
	echo " =========================================================== "
	/opt/fusioninventory-agent/bin/fusioninventory-agent
		
	echo ""
	echo "                      ============"
	echo "                          LISTO"
	echo "                      ============"
	echo " -------------------------------------------------------"
	echo "            fusioninventory-agent instalado"
	echo " -------------------------------------------------------"
	#########################################################################################
    cat > $TEMPDIR/aux.sh << 'EOF'
	DirHost=$(cat DirHost)
	PathFile=$(egrep -r 'GlpiNoBorrar' $DirHost | awk -F: 'FNR == 1 {print $1}')
	rm -rf $PathFile
EOF
	chmod +x aux.sh
	./aux.sh
	exit
fi