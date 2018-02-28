#!/bin/bash

echo
echo "******************************************"
echo "***   DEPLOIEMENT D'UNE CLE SSH        ***"
echo "******************************************"

HOME_DIR=/home/$1
PUB_KEY=$2

# Root user ?
if [ "$(id -u)" != "0" ]; then
   echo "Ce script doit être exécuté en mode root" 1>&2
   exit 1
fi

# user
if [ -z $1 ]; then
  echo -e "Le nom d'utilisateur doit être spécifié"
  exit 1
fi

# Clé publique
if [ -z $2 ]; then
  echo -e "La clé publique doit être spécifiée"
  exit 1
fi

echo ""
echo -e "Vous allez déployer la clé $2 pour l'utisateur $1 tapez une touche pour continuer ou CTRL+C pour arrêter."
read A


# Vérification répertoire utilisateur
if [ ! -d $HOME_DIR ]; then
  echo -e "le répertoire utilisateur $HOME_DIR est absent. Il est impossible de déployer la clé SSH"
  exit 1
fi

# Vérification .ssh dans le répertoire utilisateur
if [ ! -d "$HOME_DIR/.ssh" ]; then
  echo -e "Création du répertoire $HOME_DIR/.ssh"
  mkdir -p $HOME_DIR/.ssh
fi

if [ ! -f "$HOME_DIR/.ssh/authorized_keys" ]; then
  touch /home/$1/.ssh/authorized_keys
fi

# rajout de la clé
cat $2 >> $HOME_DIR/.ssh/authorized_keys

# Droits
echo -e "Modification des droits sur les fichiers $HOME_DIR/.ssh"
chown -R $1:$1 $HOME_DIR/.ssh
chmod 700 $HOME_DIR/.ssh && chmod 600 $HOME_DIR/.ssh/*

echo "*** Le déploiement de la clé est terminé"
