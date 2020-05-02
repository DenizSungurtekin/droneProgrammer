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
    var objectifs: [Objectif] = [];
    var tmpCmd: [Int] = [];
    var tmpObs: [Obstacle] = [];
    var tmpObj: [Objectif] = [];
    var obstacleVectors: [SCNVector3] = [];
    var objectifVectors: [SCNVector3] = [];
    var sphereListe: [SCNTorus] = [];
    
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
        self.objectifs = tmpObj;
        
        self.view.addSubview(sceneView)
        self.sceneView.autoenablesDefaultLighting = true
        self.sceneView.allowsCameraControl = true
        let scene = SCNScene()
              sceneView.scene = scene
              sceneView.backgroundColor = UIColor.white
              
              let camera = SCNCamera()
              
              cameraNode.camera = camera
              cameraNode.position = SCNVector3(x: 15, y: -3, z: 30)
        
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
        
        if objectifs.count > 0 {        // Met en place les obstacles
            for element in objectifs {
                let anneauTmp = SCNTorus(ringRadius: 0.5, pipeRadius: 0.1)
                anneauTmp.firstMaterial?.diffuse.contents = UIColor.black
                self.sphereListe.append(anneauTmp);
                let anneauTmpNode = SCNNode(geometry: anneauTmp)
                anneauTmpNode.position = SCNVector3(x: Float(element.posX), y: Float(element.posY), z: Float(element.posZ))
                objectifVectors += [anneauTmpNode.position]
                scene.rootNode.addChildNode(anneauTmpNode)
            }
        }

        self.cubeNode = SCNNode(geometry: cubeGeometry)
        cubeGeometry.firstMaterial?.diffuse.contents = UIColor.brown
        cubeGeometry.firstMaterial?.transparency = 0.5
        self.sphere.firstMaterial?.diffuse.contents = UIColor.blue
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
        var counter = self.objectifs.count;
        
        let decollage = SCNAction.moveBy(x: 0, y: 1, z: 0, duration: 1);
        let monter = SCNAction.moveBy(x: 0, y: 1, z: 0, duration: 1);
        let descendre = SCNAction.moveBy(x: 0, y: -1, z: 0, duration: 1);
        let droite = SCNAction.moveBy(x: 1, y: 0, z: 0, duration: 1);
        let gauche = SCNAction.moveBy(x: -1, y: 0, z: 0, duration: 1);
        let avancer = SCNAction.moveBy(x: 0, y: 0, z: -1, duration: 1);
        let reculer = SCNAction.moveBy(x: 0, y: 0, z: 1, duration: 1);
        var position = sphereNode.position;
        
        
        var monterDescendre: Int = 0;    // Compte le deplacement verticale pour connaitre la position d'atterrisage à la fin de la sequence car impossible de récuperer la valeur sur "y" de la sphère après l'éxecution de la séquence de déplacement. (la méthode run action bouge la sphère mais ne met pas à jour la position)
        var gaucheDroit: Int = 0;   // Permet de connaître la position finale en x
        var avancerReculer: Int = 0;// Permet de connâitre la position finale en z
        
        var sequences: [SCNAction] = [];
        var flagToBreakObstacle: Bool = false
        var flagPosition: Bool = false
        print("Position before sequenceies loop: ",position)
        getSequencies: for element in commandes {
           switch element{
               case 0:
                   sequences.append(decollage)
                   monterDescendre += 1
                   position.y = position.y + 1;
               case 1:
                   let atterisage = SCNAction.moveBy(x: 0, y: -CGFloat(monterDescendre), z: 0, duration: 1)
                   while position.y != -10 {
                        sequences.append(descendre)
                        position.y -= 1;
                        for obsVec in self.obstacleVectors{
                            if SCNVector3EqualToVector3(obsVec, position){
                                print("Touch an Obstacle")
                                flagToBreakObstacle = true
                            }
                        }
                        for (ind,obj) in self.objectifVectors.enumerated(){
                            if SCNVector3EqualToVector3(obj, position)
                            {
                                let currentObj = self.sphereListe[ind];
                                currentObj.firstMaterial?.diffuse.contents = UIColor.green;
                                counter -= 1;
                            }
                        }
                   }
                   sequences.append(atterisage)
                   monterDescendre = 0
                   position.y = -10
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
                   avancerReculer -= 1
                   position.z = position.z - 1
               case 5:
                   sequences.append(reculer)
                   avancerReculer += 1
                   position.z = position.z + 1
                
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
            for (ind,obj) in self.objectifVectors.enumerated(){
                if SCNVector3EqualToVector3(obj, position)
                {
                    let currentObj = self.sphereListe[ind];
                    currentObj.firstMaterial?.diffuse.contents = UIColor.green;
                    counter -= 1;
                }
            }
            if position.x < -10 || position.x > 10 || position.y < -10 || position.y > 10 || position.z < -10 || position.z > 10 {
                flagPosition = true
                
                
            }
            if flagToBreakObstacle || flagPosition{
                break getSequencies;
            }
        }
        // Collision avec un obstacle
        let moveSequence = SCNAction.sequence(sequences)
        self.sphereNode.runAction(moveSequence) {
            
            if flagToBreakObstacle{
                DispatchQueue.main.async {
                                    self.errorAlertView = UIAlertController(
                                        title: " !!!!!!!!! CRASH !!!!!!!!!",
                                        message: "L'analyse du plan de vol nous indique le drone c'est crashé avec un obstacle",
                                        preferredStyle: .alert)
                                    self.errorAlertView?.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                                    self.present(self.errorAlertView!, animated: true, completion: nil)
                }
                
            }else if flagPosition {
                DispatchQueue.main.async {
                    
                    self.errorAlertView = UIAlertController(
                                         title: "Le drone est sorti de la zone de simulation",
                                         message: "Veuillez entrer une liste de commande adéquate",
                                         preferredStyle: .alert)
                             self.errorAlertView?.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                             self.present(self.errorAlertView!, animated: true, completion: nil)
                    
                }
         
            }
            else{

                DispatchQueue.main.async { // Correct
                    if counter == 0{
                        self.errorAlertView = UIAlertController(
                                    title: "La simulation s'est bien déroulé",
                                    message: "Vous pouvez donc désormais lancer le trajet sur le drone",
                                    preferredStyle: .alert)
                        self.errorAlertView?.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(self.errorAlertView!, animated: true, completion: nil)
                        self.LaunchDroneBtn.isHidden = false
                    }else{
                        self.errorAlertView = UIAlertController(
                                     title: "Tous les obstacles n'ont pas été touché",
                                     message: "Essayer de toucher tous les obstacles la prochaine fois",
                                     preferredStyle: .alert)
                         self.errorAlertView?.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                         self.present(self.errorAlertView!, animated: true, completion: nil)
                    }


                }
                

            }
            
        }
        
    }
    @IBAction func sendDrone(_sender: Any){
        
    }
}
