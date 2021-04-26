#!/bin/bash
set -e # En cas de code de route non zero, arrêter le script

# Ce script est destiner au milestone 2 Jenkins
# Alias Zabasux (Arnaud DEGEZ)

# Fonctions
# Vérifier que le script est bien lancé en tant que root
ws_assert_root() {
	REAL_ID="$(id -u)"
	if [ "$REAL_ID" -ne 0 ]; then 
		1>&2 echo "Erreur le script doit être lancé en tant que root" 
		exit 1
	fi
}
# installation de package
ws_install_package() {
	PACKAGE_NAME="$1"
	if ! dpkg -l |grep --quiet "^ii.*$PACKAGE_NAME " ; then 
		apt-get install -y "$PACKAGE_NAME"
    fi
}
#Installation de la source du package jenkins
ws_source_package() {
    KEY="$(https://pkg.jenkins.io/debian-stable/jenkins.io.key)"
    if ! test -f /etc/apt/sources.list.d/jenkins.list ; then
        wget -q -O - KEY | apt-key add -
        sh-c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > \
        /etc/apt/sources.list.d/jenkins.list'
    fi
}

# Main
#Vérification au lancement du script (root)
ws_asset_root

#Installation du package openjdk-11-jdk et gnupg
apt-get -y update
ws_install_package "openjdk-11-jdk"
ws_install_package "gnupg"

#Enregistrement sources de Jenkins
ws_source_package

#Installation Jenkins
apt-get -y update
ws_install_package "jenkins"

systemctl start jenkins

echo "success"