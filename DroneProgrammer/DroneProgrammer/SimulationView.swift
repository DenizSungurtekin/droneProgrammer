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
        
        if obstacles.count > 0 {
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
        
           let decollage = SCNAction.moveBy(x: 0, y: 1, z: 0, duration: 1)
           let monter = SCNAction.moveBy(x: 0, y: 1, z: 0, duration: 1)
           let descendre = SCNAction.moveBy(x: 0, y: -1, z: 0, duration: 1)
           let droite = SCNAction.moveBy(x: 0, y: 0, z: -1, duration: 1)
           let gauche = SCNAction.moveBy(x: 0, y: 0, z: 1, duration: 1)
           let avancer = SCNAction.moveBy(x: 1, y: 0, z: 0, duration: 1)
           let reculer = SCNAction.moveBy(x: -1, y: 0, z: 0, duration: 1)
           var count: Int = 0;    // Compte le deplacement verticale pour mettre en oeuvre l'atterrisage à la fin de la sequence car impossible de récuperer la valeur sur y de la sphère après l'éxecution de la séquence de déplacement
        
           var sequences: [SCNAction] = [];
           for element in commandes {
               switch element{
               case 0:
                   sequences.append(decollage)
                   count += 1
               case 1:
                   let atterisage = SCNAction.moveBy(x: 0, y: -CGFloat(count), z: 0, duration: 1)
                   sequences.append(atterisage)
               case 2:
                   sequences.append(droite)
               case 3:
                   sequences.append(gauche)
               case 4:
                   sequences.append(avancer)
               case 5:
                   sequences.append(reculer)
               case 6:
                   sequences.append(monter)
                   count += 1
               case 7:
                   sequences.append(descendre)
                   count -= 1
                   
               default:
                   print("La liste de commande est vide") //Ici mettre alarme
               }
           }
        
        let moveSequence = SCNAction.sequence(sequences)
        sphereNode.runAction(moveSequence)

        let constraint = SCNLookAtConstraint(target: cubeNode)
        constraint.isGimbalLockEnabled = true
        cameraNode.constraints = [constraint]

    }
}
