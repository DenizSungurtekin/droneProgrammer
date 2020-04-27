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
    var obstacleVectors: [SCNVector3] = [];
    
    @IBOutlet var LaunchDroneBtn: UIButton!
    @IBOutlet var LaunchSimulation: UIButton!
    
    // SceneKit declaration
    @IBOutlet var sceneView: SCNView!
    let sphere = SCNSphere(radius: 0.5);
    var simulationEnded: Bool = false
    var sphereNode = SCNNode(geometry: SCNSphere(radius: 0.5))
    var cubeNode = SCNNode()
    var cameraNode = SCNNode()
    let cubeGeometry = SCNBox(width: 20, height: 20, length: 20, chamferRadius: 0.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LaunchDroneBtn.isHidden = true
        prepare()
            
    }
    func prepare(){
        self.commandes = tmpCmd;
        self.obstacles = tmpObs;
        // Gestion d'erreur lié à la semantique de nos commandes
             

             // On s'assure que le premier élément est l'action décoller
             if self.commandes[0] != 0  {
                 errorAlertView = UIAlertController(
                     title: "La liste de commande est erronée",
                     message: "Veuillez vous s'assurer que la première commande est le décollage",
                     preferredStyle: .alert)
                 errorAlertView?.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                 self.present(errorAlertView!, animated: true, completion: nil)
             }
             // On s'assure que le dernier élément est l'action atterir
             if self.commandes[commandes.count-1] != 1  {
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
        self.view.addSubview(sceneView)
        self.sceneView.autoenablesDefaultLighting = true
        self.sceneView.allowsCameraControl = true
        let scene = SCNScene()
              sceneView.scene = scene
              sceneView.backgroundColor = UIColor.white
              
              let camera = SCNCamera()
              
              cameraNode.camera = camera
              cameraNode.position = SCNVector3(x: 35, y: 15, z: 3)
              if obstacles.count > 0 {        // Met en place les obstacles
                  for element in obstacles {
                      let sphereTmp = SCNSphere(radius: 0.5)
                      sphereTmp.firstMaterial?.diffuse.contents = UIColor.red
                      let sphereTmpNode = SCNNode(geometry: sphereTmp)
                      sphereTmpNode.position = SCNVector3(x: Float(element.posX), y: Float(element.posY), z: Float(element.posZ))
                      obstacleVectors += [sphereTmpNode.position]
                      scene.rootNode.addChildNode(sphereTmpNode)
                  }
              }

        self.cubeNode = SCNNode(geometry: cubeGeometry)
        cubeGeometry.firstMaterial?.diffuse.contents = UIColor.brown
        cubeGeometry.firstMaterial?.transparency = 0.5
        self.sphere.firstMaterial?.diffuse.contents = UIColor.green
        self.sphereNode = SCNNode(geometry: self.sphere)
        scene.rootNode.addChildNode(self.cameraNode)
        scene.rootNode.addChildNode(self.cubeNode)
        scene.rootNode.addChildNode(self.sphereNode)
        sphereNode.position = SCNVector3(x: 0, y: -10, z: 0)

        let constraint = SCNLookAtConstraint(target: cubeNode)
        constraint.isGimbalLockEnabled = true
        self.cameraNode.constraints = [constraint]
        
    }
    @IBAction func simulate(_sender: Any){
        
    
        sphereNode.position = SCNVector3(x: 0, y: -10, z: 0)

        
        let decollage = SCNAction.moveBy(x: 0, y: 1, z: 0, duration: 1);
        let monter = SCNAction.moveBy(x: 0, y: 1, z: 0, duration: 1);
        let descendre = SCNAction.moveBy(x: 0, y: -1, z: 0, duration: 1);
        let droite = SCNAction.moveBy(x: 0, y: 0, z: -1, duration: 1);
        let gauche = SCNAction.moveBy(x: 0, y: 0, z: 1, duration: 1);
        let avancer = SCNAction.moveBy(x: 1, y: 0, z: 0, duration: 1);
        let reculer = SCNAction.moveBy(x: -1, y: 0, z: 0, duration: 1);
        var position = sphereNode.position;
        
        
        var monterDescendre: Int = 0;    // Compte le deplacement verticale pour connaitre la position d'atterrisage à la fin de la sequence car impossible de récuperer la valeur sur "y" de la sphère après l'éxecution de la séquence de déplacement. (la méthode run action bouge la sphère mais ne met pas à jour la position)
        var gaucheDroit: Int = 0;   // Permet de connaître la position finale en x
        var avancerReculer: Int = 0;// Permet de connâitre la position finale en z
        
        var sequences: [SCNAction] = [];
        var flagToBreakObstacle: Bool = false
        print("Position before sequenceies loop: ",position)
        getSequencies: for element in commandes {
           switch element{
               case 0:
                   sequences.append(decollage)
                   monterDescendre += 1
                   position.y = position.y + 1;
               case 1:
                   let atterisage = SCNAction.moveBy(x: 0, y: -CGFloat(monterDescendre), z: 0, duration: 1)
                   sequences.append(atterisage)
                   monterDescendre = 0
                   position.y = 0
               case 2:
                   sequences.append(droite)
                   gaucheDroit += 1
                   position.x = position.x + 1
               case 3:
                   sequences.append(gauche)
                   gaucheDroit -= 1
                   position.x = position.x - 1
               case 4:
                   sequences.append(avancer)
                   avancerReculer += 1
                   position.z = position.z + 1
               case 5:
                   sequences.append(reculer)
                   avancerReculer -= 1
                   position.z = position.z - 1
                
               case 6:
                   sequences.append(monter)
                   monterDescendre += 1
                   position.y = position.y + 1
               case 7:
                   sequences.append(descendre)
                   monterDescendre -= 1
                   position.y = position.y - 1
                   
               default:
                   print("La liste de commande est vide")
               }
            for obsVec in self.obstacleVectors{
                if SCNVector3EqualToVector3(obsVec, position){
                    print("Touch an Obstacle")
                    flagToBreakObstacle = true
                }
            }
            if flagToBreakObstacle{
                break getSequencies;
            }
        }
        let simulationEndedAction = SCNAction.customAction(duration: 0, action: {_,_ in self.simulationEnded = true})
        sequences.append(simulationEndedAction);
        let moveSequence = SCNAction.sequence(sequences)
        self.sphereNode.runAction(moveSequence){
            let positionFinale: SCNVector3 = SCNVector3(x: Float(0+gaucheDroit), y: Float(-10+monterDescendre), z: Float(0+avancerReculer))
            if flagToBreakObstacle{
                self.errorAlertView = UIAlertController(
                    title: " !!!!!!!!! CRASH !!!!!!!!!",
                    message: "L'analyse du plan de vol nous indique le drone c'est crashé avec un obstacle",
                    preferredStyle: .alert)
                self.errorAlertView?.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(self.errorAlertView!, animated: true, completion: nil)
                
            }else if positionFinale.x < -10 || positionFinale.x > 10 || positionFinale.y < -10 || positionFinale.y > 10 || positionFinale.z < -10 || positionFinale.z > 10 {
                print("Erreur, dehors de la boite")
                self.errorAlertView = UIAlertController(
                            title: "Le drone a atterrie hors du champ de simulation",
                            message: "Veuillez entrer une liste de commande sensée",
                            preferredStyle: .alert)
                self.errorAlertView?.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(self.errorAlertView!, animated: true, completion: nil)
            }
            else{
                DispatchQueue.main.async { // Correct
                    self.LaunchDroneBtn.isHidden = false
                }
            }
        }
        
    }
    @IBAction func sendDrone(_sender: Any){
        
    }
}
