#!/bin/bash

echo “####################Descargando archivos necesarios####################”

curl -O https://ftp.mozilla.org/pub/firefox/releases/52.0esr/mac/en-US/Firefox%2052.0esr.dmg
curl -L -o Firefox.zip https://www.dropbox.com/sh/n1tv3yu1w6zgrs2/AAAg-da9JBcHPGkfpgADXu9Xa?dl=1
curl -L -O https://www.dropbox.com/s/4ixuorqlzqixbq9/jre-8u221-macosx-x64.dmg
curl -L -o Oracle.zip https://www.dropbox.com/sh/t2g2g9en4zdk4oh/AADA0RBYPx2G5gW-swbojIrHa?dl=1 
sudo easy_install pip && sudo pip install termdown
echo “”

echo “####################Montando y verificando detalles####################”

sudo hdiutil attach -nobrowse Firefox%2052.0esr.dmg 
sudo cp -R -v /Volumes/Firefox/Firefox.app /Applications/EBSORACLE

sudo hdiutil attach -nobrowse jre-8u221-macosx-x64.dmg
echo “”

echo “####################Instalando####################”

sudo cp -R -v /Volumes/Firefox/Firefox.app /Applications/EBSORACLE
sudo mv /Applications/EBSORACLE/Firefox.app /Applications/EBSORACLE/EBS.ORACLE.app 
cp -R -v /Applications/EBSORACLE/EBS.ORACLE.app ~/Desktop
open /Volumes/Java\ 8\ Update\ 221/Java\ 8\ Update\ 221.app/


read -r -p "Se instalo Java correctamente? Presiona Enter para continuar [Yy/n]" response
 response=${response}
 if [[ $response =~ ^(Y|yes|y| ) ]] || [[ -z $response ]]; then
 	true
 else
 	echo "Se necesita Java para continuar"
 	exit
 fi
echo ""

echo “####################Desmontando DMG####################”

sudo hdiutil detach /Volumes/Firefox/
unzip -a Oracle.zip
mv ~/Library/Application\ Support/Oracle/ ~/Library/Application\ Support/Oracle.old
cp -R ~/Desktop/Oracle ~/Library/Application\ Support/

unzip -a Firefox.zip
mv ~/Library/Application\ Support/Firefox/ ~/Library/Application\ Support/Firefox.old
cp -R ~/Desktop/Firefox ~/Library/Application\ Support/

sudo rm -rf -v Firefox%2052.0esr.dmg
sudo rm -rf -v jre-8u221-macosx-x64.dmg
sudo rm -rf -v Oracle.zip && sudo rm -rf Oracle
sudo rm -rf -v Firefox.zip && sudo rm -rf Firefox
sudo chmod -R 777 ~/Library/Application\ Support/Firefox
sudo chmod -R 777 ~/Library/Application\ Support/Oracle
echo ""

echo “####################Configurando Perfil####################”
sudo defaults write /Library/Preferences/com.oracle.java.Java-Updater JavaAutoUpdateEnabled -bool false


termdown 3
sudo pip uninstall termdown -y

open ~/Desktop/EBS.ORACLE.app
sudo rm -rf ~/Desktop/bigpapi_1.1.sh
clear
echo “####################Todo listo! prendele fuego a esas rendiciones de gastos! @Metaforicamente@ .wink .wink :D####################”
echo ""

exit


:'
echo "Linux/DEBIAN"

apt install java


echo"

java --version

if [[ response=~[openjdk 11.0.3] ]]; then
	echo "Desea continuar?"
	echo"
elif [[ response=~ [Nn, n]  ]]; then
	echo "No se ha podido validar version de java, para continuar con la instalacion debe  realizar la validacion"
fi

exit
'