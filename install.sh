#/bin/bash
configPath="/usr/local/lib"
scriptPath="/usr/local/bin"
servicePath="/etc/systemd/system"

gpio -v
if [ $? -gt 0 ]; then
	echo "L'utilitaire gpio n'est pas installé, tentative d'installation"
	sudo apt update && sudo apt install gpio
	if [ $? -gt 0 ]; then
		echo "Impossible d'installer gpio, consultez la documentation de votre distribution"ù
		exit 127
	fi
fi

echo "Récupération et installation du dépôt HelpSh"
if [ -d HelpSh ]; then
	del=0
	cd HelpSh
	git pull
	ret=$?
	cd ..
else
	del=1
	git clone https://github.com/Anard/HelpSh.git
	ret=$?
fi
if [ $ret -gt 0 ]; then echo "Une erreur est survenue lors du clonage de HelpSh"; exit $ret; fi

sudo cp HelpSh/*.cnf ${configPath}/
ret=$?; if [ $ret -gt 0 ]; then echo "Une erreur est survenue lors de la copie des fichiers de configuration"; exit $ret; fi

if [ $del -gt 0 ]; then
	sudo rm -r HelpSh
fi

echo "Installation de FanControl"
sudo cp *.cnf ${configPath}/
ret=$?; if [ $ret -gt 0 ]; then echo "Une erreur est survenue lors de la copie des fichiers"; exit $ret; fi
sudo cp fancontrol ${scriptPath}
ret=$?; if [ $ret -gt 0 ]; then echo "Une erreur est survenue lors de la copie des fichiers"; exit $ret; fi
sudo cp *.service ${servicePath}
ret=$?; if [ $ret -gt 0 ]; then echo "Une erreur est survenue lors de la copie des fichiers"; exit $ret; fi
sudo systemctl daemon-reload
ret=$?; if [ $ret -gt 0 ]; then echo "Une erreur est survenue lors du démarrage du système"; exit $ret; fi
sudo systemctl enable fancontrol
ret=$?; if [ $ret -gt 0 ]; then echo "Une erreur est survenue lors du démarrage du système"; exit $ret; fi

echo "Service fancontrol installé avec succès"
echo "Vous pouvez modifier la configuration dans ${configPath}/fancontrol.cnf"
echo "Redémarrez le système ou démarrer le contrôle avec ${orange}sudo systemctl (re)start fancontrol${nocolor}"

exit 0
