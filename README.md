# FanControl-RasPi
Contrôle de la température CPU et du ventilateur sur RaspberryPi

## Installation

```
git clone https://github.com/Anard/FanControl-RasPi.git
cd FanControl-RasPi
chmod +x install.sh
./install.sh
```

Possibilité de modifier la configuration (limites de températures CPU et hystérésis, valeurs PWM du ventilateur, GPIO utilisés pour le ventilateur et l'alame) en modifiant le fichier fancontrol.cnf

## TODO
- Tester l'implémentation du bipper
- Allumage de LEDs pour indiquer plus visuellement la vitesse actuelle du ventilateur
- ET/OU Affichage d'une notification zenity pour les plus hauts paliers
- Voir à supprimer la boucle infinie pour un appel de fancontrol toutes les x secondes
- Voir à autoriser un passage à la vitesse supérieure sans modification de la température pendant x secondes
