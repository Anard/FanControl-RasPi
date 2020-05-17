#/bin/bash
configPath="/usr/local/lib"
scriptPath="/usr/local/bin"
servicePath="/etc/systemd/system"

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
if [ $ret -gt 0 ]; then 
	echo "Une erreur est survenue lors du clonage de HelpSh"
	exit $ret
fi
sudo cp HelpSh/*.cnf ${configPath}/
ret=$?
if [ $ret -gt 0 ]; then
	echo "Une erreur est survenue lors de la copie des fichiers de configuration"
	exit $ret
fi

if [ $del -gt 0 ]; then
	sudo rm -r HelpSh
fi

echo "Installation de FanControl"
sudo cp *.cnf ${configPath}/
if [ $? -gt 0 ]; then echo "Une erreur est survenue lors de la copie des fichiers"; exit 1; fi
sudo cp fancontrol ${scriptPath}
if [ $? -gt 0 ]; then echo "Une erreur est survenue lors de la copie des fichiers"; exit 1; fi
sudo cp *.service ${servicePath}
if [ $? -gt 0 ]; then echo "Une erreur est survenue lors de la copie des fichiers"; exit 1; fi
sudo systemctl daemon-reload
if [ $? -gt 0 ]; then echo "Une erreur est survenue lors du démarrage du système"; exit 1; fi
sudo systemctl enable fancontrol
if [ $? -gt 0 ]; then echo "Une erreur est survenue lors du démarrage du système"; exit 1; fi

echo "Service fancontrol installé avec succès"
echo "Vous pouvez modifier la configuration dans ${configPath}/fancontrol.cnf"
echo "Redémarrez le système ou démarrer le contrôle avec ${orange}sudo systemctl start fancontrol${nocolor}"

exit 0