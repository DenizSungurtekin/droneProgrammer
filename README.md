# DroneProgrammer
## Prérequis:
Afin d'installer et de travailler avec cette application il est nécessaire d'être équipée de la manière suivante:

- Un ordinateur avec MacOS
- xCode
- Un drone Parrot bepob 2
- Cloner le repository GitHub
- Vérifier que  [ces champs](https://developer.parrot.com/docs/SDK3/#iosd) soient remplis correctement

## But de l'application
Le but de l’application droneProgrammer est de pouvoir piloter un drone bebop2 de la marque Parrot.
Il y’a plusieurs moyens de piloter le drone :
1.  Un pilotage live où le drone réagit au divers bouton pressé. Ce mode sera appelé « Free flight » dans le reste de cette documentation ainsi que dans le code de l’application.
2. Un pilotage programmé, où il est possible de programmer le plan de vol du drone. Dans ce mode, il faut entrer une suite de commande ainsi que la position des obstacles et des objectifs. Il est ensuite possible de simuler le vol afin de vérifier si le drone touche tous les objectifs et aucun obstacle avant de le lancer.


## Fonctionnement globale de l' application :
1. Photo storyboard

1. Le storyboard de l’application est le suivant : On commence par une vue initiale, c’est un menu où il y’a trois options:
	1. « Free flight »
	
	2. « Gestionnaire » On y trouve une liste de plan de vol sauvegardée depuis la planification de vol. Lorsqu’on choisit un plan de vol on arrive directement au mode créateur avec ce plan de vol.

	3.	« Plan de Vol » qui correspond à un mode création de plan de vol. Il est possible d’ajouter les commandes suivantes :
		-	décoller
		-	Atterrir
		-	Tourner à droite
		-	Tourer à Gauche
		-	Avancer
		-	Reculer
		-	Monter
		-	Descendre
    
Il est également possible d’ajouter des obstacles et des objectifs qui sont représentés en coordonnées (x,y,z). Une fois que le plan de vol est créé il est possible de le simuler. Si la simulation réussie, (Tous les objectifs touchés et aucun obstacles percutés) il est alors possible de se connecter au drone et de le lancer.
 

## Les technologies utilisées :
•	Swift -> Langage de programmation de l’application

•	Json -> Encodage des plans de vols

•	SceneKit -> Librairie 3D pour la simulation

•	Objective-C -> Langage de programmation pour les samples du drone.

Il est conseillé d’avoir de bonnes connaissances dans les trois premières technologies, la dernière n’est que peu utilisée. Cependant, pour aller plus loin, il est possible d’utiliser directement l’API du drone, qui est écrite en objective-C et qui permet d’aller plus loin que les samples.
