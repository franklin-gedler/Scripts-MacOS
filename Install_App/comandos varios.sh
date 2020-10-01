

# Agrega al usuario como admin local
dseditgroup -u admindesp -P *Gr4lPeron1710-18:55* -o edit -a $USER -t user admin


# Cambiar nombre de equipo
sudo scutil --set HostName <new host name>
sudo scutil --set LocalHostName <new host name>
sudo scutil --set ComputerName <new name>


# comando para sacar la MacOS del AD
sudo dsconfigad -f -r -u franklin.gedler -p Sabri-Ele-Frank1801.-.



# pegar a dominio equipo MacOS
sudo dsconfigad -add ar.infra.d -force -computer frankMacOS --domain DC=AR,DC=INFRA,DC=D -username franklin.gedler -password Diaz-Elenys1801.-. -alldomains enable -mobile enable -mobileconfirm disable -useuncpath enable


listar grupos: dscl . list /groups | grep -v '_'



ver usuarios que estan dentro de ese grupos: 
	dscl . -read /Groups/nombre-del-grupo GroupMembership
	dscacheutil -q group -a name nombre-del-grupo


Agregar usuarios a un grupo: 
	dseditgroup -u admindesp -P *Gr4lPeron1710-18:55* -o edit -a $USER -t user admin


ls -la /Library/Application\ Support/com.apple.TCC/TCC.db
	-rw-r--r--  1 root  wheel  57344 Jul 16 13:54 /Library/Application Support/com.apple.TCC/TCC.db


agregue a admindesp al grupo admin, wheel y staff