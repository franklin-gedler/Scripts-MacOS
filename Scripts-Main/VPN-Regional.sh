#!/bin/bash
#VPNRegionalNoBorrar

ConfigVpnRegional(){
cat > $TEMPDIR/Trac.config << 'EOF'
11TRAC381b7e607b647e67747879676a637c1c18235e7b170d601067080b0f426a1b7207101a057c0b127d79706f72105d1809041b07196b73131140464b04504e5855474c52423e5e4d1841474a4451404a434a51535e171c5a444857735a454d5d3724650572170964170f68746917744f7b1a760a010d081f1d140c7706646543786b160a7e66161e574f515a1f62726c621a300c263f10767160671d19100f380e6d70726a6f6c6b7e791c1809746565420d0809666a7f6768771530372a3f402a3522683522335e254337306b7b2d2b275956597c4b454b5b5e535e4b5943785859540e7e647b756219100f12101f152b017d60766d6f1c1817763120261d3729534e5f3b312d192624682747363937373f3c3753344766782c2b282a3b5e5c5c7c524d02627e62766f0b06300c0c150e391b6475606460000e0e1d001911001315020a1d14196667783a5721294442702c3a39417408041a7209687265706f72105d1809041b07196b73131140464b04504e5855474c52423e5e4d1841474a4451404a434a51535e171c5a5d404a7346524859272c21687e041a757b136874691774654f767e180613157f736c12621e6a757b776771611d0306011858464b5e405e60404130616d676f631909141205100f380e7274737e600e18121d5657453523677552243b6b5846681908651515796813797472655a711f710567146a75786b2a3f5b1109474c754f435e5545605343644f49594b400564756064601312101f15011f3a1f76696c667b641b1703741365681421111f13167a1b1703670f797472655a711f710567146a75786b717e150705101c18141e1d0d52525e524f584f50405d4a4a6b5b55514647534c156c7e626074101f13040974654f767e041a757b00746a6b076470716a0e2d263d350f3b205f27552a243b3216303b4c5d146e6478637f0310171f1706302612786f6164791b0e1b121c06041d08554d5f517b584d5c545a3a24373c6c3138575f0f05151b7604796568137974724f6e1b11751d640b6a756669646f0d133e1d716967657d7f18031706300c0c150e132f17505e4059691d0c0117101d0d4451405e45040b3929242d6132275c580d753124563a6521245630126e65706f721077066465694c772023485a720c1914001f1d0d524a5b47660c0e746f605640160f405d4e5c105b594456761d040c1f13040974656568397b2c584e460e7b75097675757911643127293139721232563d1121323c052b485d5d45406e504a4c65535a4345754049460c0e4044555c05544357597909011f1001040c1f1304095e7b2124562c0e1b17116a7674522129243e137b313f243e3d374322047920242727642b41565d65190a020f1f10171f17063026125142564c6f1b0e1b120d0f554a59404910034c585e63415d35262c2e5a313a51480d753124563a6521245630126e65706f721077066465694c772023485a720c1914001f1d0d524a5b47660c0e505e4a714c40534659495b444d50625b555547495356570b692028295d652c584e460e68691774656568137974724f6e2b3e553e606b79776479667248465842530a004b7655454a5443434849414d56494c4710185542535e1f514d5a5967180c1f13040974656568134f7650474a2112660b6a67756a0e3c213e24266f7055275f10203d272a2d2944474646664e4758505c5b5e151b75414d5b0e57494c5d7419100f12101f15011f10012e125b5f4140126a797611756a094e5a24353f1776203531673d1d3737252c37633343332a252a286672485e554d054e4e4a56760b1f1706300c0c150e1305230a66667565707f1009011f1001040c1f1304095e7b110b760f0a7b04136874691774656568137974724f6e2b3e553e606b7977642c20204e40474275081f4a4a5c564917047c494e5462575746434156515f100d5a584051104548495675180974656568136568140b0f6874693d6a21292d5a1f7b6e7b723d3743020605161b6474213a415242030746474d5e7c5252564862495f400c0e4044555c05544357597909011f1001040c1f13040974656568397b2c584e460e7b75097604161a133c30723635233359344821212c342a643c58401446564f50485179150252537c4d5a150c41404d55576d424046535e530302554c45421f57484c3d037968136568140b0f68746917746565420d3d38372c16606e0e751766782c332525390d1151535c7e4a5b4a511502524b71420c5142564c6f081205100f12101f15011f1001040c350d065b3b312629752b275d5f4e2b3d3d59312d313d727b693735293b7212234821282c2a0c6672485e554d057e616a757278031706300c0c150e13050914122f0e0d6f425041425e764f4b454b524740202b20204730096f59403c372c61767820384a2d74703634203a44326b2c303d0724282e4841161e404743411f64747a7d645f100c150e13050914120510250c54535048791f1d1a0e0d11194c2129243e13673b415f4e3c0727583d31243a463e3d342b3f0c3f5c3643366774232425210d5758464c6c1e0f1f10171f1706300c0c3f1057494c5d740a0c1110030b00135e554310485b56401f67247029047379554e4a2b327c033171742e0b7b6937303c2e2410754e3724012b25252a7f4a464241444d4c5a431502524b71420c5142564c6f081205100f12101f15011f3a1f40405a5a6206687b6720473009196a7c1a7674522129243e137b313f241e36335c27552d01242a28213d0f0e514e4444024b53555e790b06300c0c150e13050914381b54435759791a1d01124f545a1d0e415c3824336811010159474e2d266b0a31282426133d38372c1673721077066465696669644513115a4c4c5e435d4a575e595949534140544b61071451425c440f104451504c5a5c6406115a5e45477411060d790707080b0f6874691774654f7611043a3d2c242e2045304f222b260524282e48616f514a5e414a69120a5a475f640c0e415d5a4976475c4a595b425f605b48585f4d06115a5e45477411060d790707080b0f687469175e7b08096118047d796e6d670879167674677367747f1f110951414e435f566f5351475030616d676f631909141205100f380e7274737e600e18121d41415a211a2e3b526775514f40250b2c533537223846063b372b7002136216767865696669646f270d7962776b7200030e151d0a4275404e5440567a475b5b51534a46555b6a5550405250435713064c2137316a0e202c5d484a2c0b3d59312c292b13141500040073721077066465437804051d6c631b1f1b08776a767c17797263520c7b706670056e617a05646377671f7075707e016162767e047006156509761709146d6a01126971120402687d180610676d3b3c59255636202e282022104e505703686b706e6f0c171f1706300c260b63727768641d190e0d05040c05100d0213111d1d0e48482237203c5d2c175146463c0b3d54312b2b2750062021243c6f1f7105671479696669646f0d390a6e6478637f100c091d5443437c651713565550406d4b5e4051107274737e601d040c1f1304095e7b08096104181b17116a202a52202001655c2d2113676d3b205f27552a243b3269090e7f72641f050a020f1f103d017a67426d7c1a120d071b060215001f070307171c515f48575e5a457b5d3a202c2450650575796e18686917746565683967191317111f7d0c69046b09050301170c0211094f575f7d4a5b51455847534f4f4d475a1368686673750c0f12101f1501350e6c657e7e630b156a67203d41316a094f4a24362859311a312656303831651d0e0071071a64656966696445137e7571647a0d13011272717665306279670e6a706e147e69757c127e7e786e1f7e646c0c747261657409171d7b650c7a7e6968111976740d1000131d11170d7272265e3e5434372c21272d297252577c494b4c5d5a445956176b517e6d65121305091412053a117f716d7471100c1f06495b5a474c301a3126562c245709122c3b214331281a265c30203326393b3c553f523124163225312e4b565003686b706e6f0c171f1706300c260b63727768641d190e0d03020f07010a051b121e050515096c74652f460468504e786a692c5a3d311a3c503c3a3c2a33102643364a640808140814730d131403050a28117271657e67092c120e71676c6b667d6176757c6d7e6f63626f7303194952524a76312c2e275c2668796a7d090475177465656813536a1f04020e021f6b1866312c2867362e4a564450404e0c051d0d595c6854755a5e505d1368686673750c0f12101f1501350e6c657e7e630b156a6770790b717907121d7e656b0a2428243c4006313f2c2410374436423430162a3c223c5e56574050597d5b4c515b1f7a67426d7c090e13050914122f0e6273627e650e030e0341594d470614272b2a214735276b45462f3b25682720363d6c3c203b367002136216767865696669646f270d7962776b7200030e155a444a714a0e084b574a446b51476f5855107274737e601d040c1f1304095e7b08096104181b17116a6479067678372d4506383d263f3b3d4227792b2925232164026c617573190a020f1f101735096b517e6d65010f1b0b1b4657554c1d434b5b44565c420b0e025f565c0b203129502c2e5d5f5d2d37697a151704180f79747265706f580e00611b0806140f786f0d1314291b08706a6c651502454363590c175a564b07465342555f41555b1b535e1d4e5043525656462720262b52677551464e26740c631d16796813535e6c0b1f0606710573030c0f0806077327
EOF
}

Vpn(){
	echo ""
	echo "=============================================================="
	echo "                  Instalando VPN Regional . . .               "
	echo "=============================================================="
	ConfigVpnRegional
	curl -LO# $1
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
}

Install(){

	Checkpoint="https://github.com/franklin-gedler/VPN-MacOS/releases/download/VPN-MacOS/Endpoint_Security_VPN_E84_70.pkg"
	CurrentInstalled=$(ls -la /Applications | egrep -o "Endpoint\ Security\ VPN.app")

	if [[ -z $CurrentInstalled ]]; then
		# Ninguna instalacion de checkpoint, solo instalo
		Vpn $Checkpoint Endpoint_Security_VPN_E84_70.pkg
	else
		# Instalacion de Checkpoint existente, se desinstala y se instala de vuelta
		/Library/Application\ Support/Checkpoint/Endpoint\ Connect/uninstall --uninstall
		Vpn $Checkpoint Endpoint_Security_VPN_E84_70.pkg

	fi

	#CheckpointCatalina="https://github.com/franklin-gedler/VPN-MacOS/releases/download/VPN-MacOS/Endpoint_Security_VPN_E82-Catalina.pkg"
    #CheckpointMojave="https://github.com/franklin-gedler/VPN-MacOS/releases/download/VPN-MacOS/Endpoint_Security_VPN_E80.71-Mojave.pkg"
    #MacVersion=$(sw_vers -productVersion | awk -F '.' '{print $1 "." $2}')
	#if [[ "$MacVersion" = "10.14" ]]; then
	#	Vpn $CheckpointMojave Endpoint_Security_VPN_E80.71-Mojave.pkg
	#else
	#	Vpn $CheckpointCatalina Endpoint_Security_VPN_E82-Catalina.pkg
	#fi
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
	PathFile=$(egrep -r 'VPNRegionalNoBorrar' $DirHost | awk -F: 'FNR == 1 {print $1}')
	rm -rf $PathFile
EOF
	chmod +x aux.sh
	./aux.sh
	exit
fi