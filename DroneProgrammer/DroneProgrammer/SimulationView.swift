//
//  SimulationView.swift
//  DroneProgrammer
//
//  Created by Mathias Tonini on 03.04.20.
//  Copyright © 2020 CUI. All rights reserved.
//


/*  Lien entre numéro et les commandes
 0: Decollage
 1: Aterrisage
 2: Droite
 3: Gauche
 4: Avancer
 5: Reculer
 6: Monter
 7: Descendre
 */

import Foundation
import SceneKit
import UIKit

class SimulationView: UIViewController ,UIAlertViewDelegate{
    
    
    var errorAlertView: UIAlertController?
    
    var commandes: [Int] = [];
    var obstacles: [Obstacle] = [];
    var tmpCmd: [Int] = [];
    var tmpObs: [Obstacle] = [];
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareScence()
        
    }
    func prepareScence(){
        
        commandes = tmpCmd;
        obstacles = tmpObs;
        
        
        // Gestion d'erreur lié à la semantique de nos commandes
        

        // On s'assure que le premier élément est l'action décoller
        if commandes[0] != 0  {
            errorAlertView = UIAlertController(
                title: "La liste de commande est erronée",
                message: "Veuillez vous s'assurer que la première commande est le décollage",
                preferredStyle: .alert)
            errorAlertView?.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(errorAlertView!, animated: true, completion: nil)
        }
        // On s'assure que le dernier élément est l'action atterir
        if commandes[commandes.count-1] != 1  {
            errorAlertView = UIAlertController(
                title: "La liste de commande est erronée",
                message: "Veuillez vous s'assurer que la dernière commande est l'attérissage'",
                preferredStyle: .alert)
            errorAlertView?.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(errorAlertView!, animated: true, completion: nil)
        }
        
        // On compte le nombre d'occurence de la commande décoller et atterir pour vérifier leur unicité (pas de fonction prédéfinis sur swift)
        var listeAtterir: [Int] = [];
        var listeDecoller: [Int] = [];
        for element in commandes {
            if element == 0{
                listeDecoller.append(0)
            }
            if element == 1{
                listeAtterir.append(1)
            }
        }
        // On s'assure que le décollage est unique
        if listeDecoller.count > 1  {
            errorAlertView = UIAlertController(
                title: "La liste de commande est erronée",
                message: "Veuillez vous que la commande décoller est unique",
                preferredStyle: .alert)
            errorAlertView?.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(errorAlertView!, animated: true, completion: nil)
        }
        // On s'assure que l'attérissage est unique
        if listeAtterir.count > 1  {
            errorAlertView = UIAlertController(
                title: "La liste de commande est erronée",
                message: "Veuillez vous que la commande attérire est unique",
                preferredStyle: .alert)
            errorAlertView?.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(errorAlertView!, animated: true, completion: nil)
        }
        
      
        
        let sceneView = SCNView(frame: self.view.frame)
        self.view.addSubview(sceneView)
        sceneView.autoenablesDefaultLighting = true
        sceneView.allowsCameraControl = true
            
        let scene = SCNScene()
        sceneView.scene = scene
        sceneView.backgroundColor = UIColor.white
        
        let camera = SCNCamera()
        let cameraNode = SCNNode()
        cameraNode.camera = camera
        cameraNode.position = SCNVector3(x: 35, y: 15, z: 3)
        
        if obstacles.count > 0 {        // Met en place les obstacles
            for element in obstacles {
                let sphereTmp = SCNSphere(radius: 0.5)
                sphereTmp.firstMaterial?.diffuse.contents = UIColor.red
                let sphereTmpNode = SCNNode(geometry: sphereTmp)
                sphereTmpNode.position = SCNVector3(x: Float(element.posX), y: Float(element.posY), z: Float(element.posZ))
                scene.rootNode.addChildNode(sphereTmpNode)
            }
        }
        
        let sphere = SCNSphere(radius: 0.5)
        let sphereNode = SCNNode(geometry: sphere)
        sphereNode.position = SCNVector3(x: 0, y: -10, z: 0)
        let cubeGeometry = SCNBox(width: 20, height: 20, length: 20, chamferRadius: 0.0)
        let cubeNode = SCNNode(geometry: cubeGeometry)
        
        cubeGeometry.firstMaterial?.diffuse.contents = UIColor.brown
        cubeGeometry.firstMaterial?.transparency = 0.5
        sphere.firstMaterial?.diffuse.contents = UIColor.green

        scene.rootNode.addChildNode(cameraNode)
        scene.rootNode.addChildNode(cubeNode)
        scene.rootNode.addChildNode(sphereNode)
        
        let decollage = SCNAction.moveBy(x: 0, y: 1, z: 0, duration: 1);
        let monter = SCNAction.moveBy(x: 0, y: 1, z: 0, duration: 1);
        let descendre = SCNAction.moveBy(x: 0, y: -1, z: 0, duration: 1);
        let droite = SCNAction.moveBy(x: 0, y: 0, z: -1, duration: 1);
        let gauche = SCNAction.moveBy(x: 0, y: 0, z: 1, duration: 1);
        let avancer = SCNAction.moveBy(x: 1, y: 0, z: 0, duration: 1);
        let reculer = SCNAction.moveBy(x: -1, y: 0, z: 0, duration: 1);
        
        var monterDescendre: Int = 0;    // Compte le deplacement verticale pour connaitre la position d'atterrisage à la fin de la sequence car impossible de récuperer la valeur sur "y" de la sphère après l'éxecution de la séquence de déplacement. (la méthode run action bouge la sphère mais ne met pas à jour la position)
        var gaucheDroit: Int = 0;   // Permet de connaître la position finale en x
        var avancerReculer: Int = 0;// Permet de connâitre la position finale en z
        
           var sequences: [SCNAction] = [];
           for element in commandes {
               switch element{
               case 0:
                   sequences.append(decollage)
                   monterDescendre += 1
               case 1:
                   let atterisage = SCNAction.moveBy(x: 0, y: -CGFloat(monterDescendre), z: 0, duration: 1)
                   sequences.append(atterisage)
                   monterDescendre = 0
               case 2:
                   sequences.append(droite)
                   gaucheDroit += 1
               case 3:
                   sequences.append(gauche)
                   gaucheDroit -= 1
               case 4:
                   sequences.append(avancer)
                   avancerReculer += 1
               case 5:
                   sequences.append(reculer)
                   avancerReculer -= 1
               case 6:
                   sequences.append(monter)
                   monterDescendre += 1
               case 7:
                   sequences.append(descendre)
                   monterDescendre -= 1
                   
               default:
                   print("La liste de commande est vide")
               }
           }
        
        let moveSequence = SCNAction.sequence(sequences)
        sphereNode.runAction(moveSequence)

        let constraint = SCNLookAtConstraint(target: cubeNode)
        constraint.isGimbalLockEnabled = true
        cameraNode.constraints = [constraint]
        
         // Calcul de la position finale de la sphère pour savoir si on dépasse le cube à la fin du trajet
        let positionFinale: SCNVector3 = SCNVector3(x: Float(0+gaucheDroit), y: Float(-10+monterDescendre), z: Float(0+avancerReculer))
        print(positionFinale)
        
        if positionFinale.x < -10 || positionFinale.x > 10 || positionFinale.y < -10 || positionFinale.y > 10 || positionFinale.z < -10 || positionFinale.z > 10 {
            errorAlertView = UIAlertController(
                title: "Le drone a atterrie hors du champ de simulation",
                message: "Veuillez entrer une liste de commande sensée",
                preferredStyle: .alert)
            errorAlertView?.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(errorAlertView!, animated: true, completion: nil)
        }
        
       
        

    }
}
