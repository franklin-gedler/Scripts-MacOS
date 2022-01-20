#!/bin/bash

filevaultsendmail(){

cat << EOF >> /etc/postfix/main.cf
# Postfix as relay
#
#Gmail SMTP
relayhost=smtp.gmail.com:587
#Hotmail SMTP
#relayhost=smtp.live.com:587
#Yahoo SMTP
#relayhost=smtp.mail.yahoo.com:465
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

	sed -i '' 's/inet_interfaces = loopback-only/#inet_interfaces = loopback-only/g' /etc/postfix/main.cf

	echo 'smtp.gmail.com:587 email@gmail.com:Password' >> /etc/postfix/sasl_passwd

	chmod 600 /etc/postfix/sasl_passwd

	postmap /etc/postfix/sasl_passwd

	echo "$passfilevault" | mail -s "$serial" email@gmail.com

	rm -rf /etc/postfix/sasl_passwd # NO Borrar

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

    file=$(ls -la ~/Desktop | grep -i "C02*" | awk '{print $9}')
    serial=$(cat ~/Desktop/$file | awk -F';' '{ print $1 }')

    passfilevault=$(cat ~/Desktop/$file | awk -F';' '{ print $2 }')

    filevaultsendmail

    #############################################################################################
    cat > $TEMPDIR/aux.sh << 'EOF'
	DirHost=$(cat DirHost)
	PathFile=$(egrep -r 'Prepare-MacOS.sh' $DirHost | awk -F: 'FNR == 1 {print $1}')
	rm -rf $PathFile
EOF
	chmod +x aux.sh
	./aux.sh
	exit
fi