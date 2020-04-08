//
//  SimulationView.swift
//  DroneProgrammer
//
//  Created by Mathias Tonini on 03.04.20.
//  Copyright © 2020 CUI. All rights reserved.
//


/*
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
        
        print(commandes)
        for element in obstacles{
            print(element.posX)
            print(element.posY)
            print(element.posZ)
            print("-------")
        }
        
        let decollage = SCNAction.moveBy(x: 0, y: 1, z: 0, duration: 1)
        let monter = SCNAction.moveBy(x: 0, y: 1, z: 0, duration: 1)
        let descendre = SCNAction.moveBy(x: 0, y: -1, z: 0, duration: 1)
        let droite = SCNAction.moveBy(x: 0, y: 0, z: -1, duration: 1)
        let gauche = SCNAction.moveBy(x: 0, y: 0, z: 1, duration: 1)
        let avancer = SCNAction.moveBy(x: 1, y: 0, z: 0, duration: 1)
        let reculer = SCNAction.moveBy(x: -1, y: 0, z: 0, duration: 1)
        let atterisage = SCNAction.moveBy(x: 0, y: 0, z: 0, duration: 1)  // A modifier
        
        var sequences: [SCNAction] = [];
        for element in commandes {
            switch element{
            case 0:
                sequences.append(decollage)
            case 1:
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
            case 7:
                sequences.append(descendre)
                
            default:
                print("La liste de commande est vide") //Ici mettre alarme
            }
            

            
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
        
        
        if obstacles.count > 0 {
            for element in obstacles {
                let sphereTmp = SCNSphere(radius: 0.5)
                sphereTmp.firstMaterial?.diffuse.contents = UIColor.black
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
        
        
        
        
//        let vertices: [SCNVector3] = [
//            SCNVector3(1, 2, 3),
//            SCNVector3(-1, -1, -1)
//        ]
//
//        let linesGeometry = SCNGeometry(
//            sources: [
//                SCNGeometrySource(vertices: vertices)
//            ],
//            elements: [
//                SCNGeometryElement(
//                    indices: [Int32]([0, 1]),
//                    primitiveType: .line
//                )
//            ]
//        )
//        let line = SCNNode(geometry: linesGeometry)
        
        cubeGeometry.firstMaterial?.diffuse.contents = UIColor.blue
        cubeGeometry.firstMaterial?.transparency = 0.3
//        linesGeometry.firstMaterial?.diffuse.contents = UIColor.red
        sphere.firstMaterial?.diffuse.contents = UIColor.red
        //cubeNode.opacity = 0.5
        //cubeGeometry.widthSegmentCount = 10
        //heightSegmentCount = 10
        //cubeGeometry.lengthSegmentCount = 10
        //cubeNode.geometry?.firstMaterial?.fillMode = .lines
        //cubeGeometry.firstMaterial?.fillMode = .lines
    
       // sphereNode.localTranslate(by: SCNVector3(x: 1, y: 1, z: 1))
        
        scene.rootNode.addChildNode(cameraNode)
        scene.rootNode.addChildNode(cubeNode)
//        scene.rootNode.addChildNode(line)
        scene.rootNode.addChildNode(sphereNode)
        
//        for element in commandes {            // Run les actions en mette temps: ex si haut droite -- il monte en diagonale
//            switch element{
//            case 0:
//                sphereNode.runAction(decollage)
//                print("Commande ok")
//         /*   case 1:
//                sphereNode.runAction()*/
//            case 2:
//                sphereNode.runAction(droite,completionHandler: )
//                print("Commande ok")
//            case 3:
//                sphereNode.runAction(gauche)
//                print("Commande ok")
//            case 4:
//                sphereNode.runAction(avancer)
//                print("Commande ok")
//            case 5:
//                sphereNode.runAction(reculer)
//                print("Commande ok")
//            case 6:
//                sphereNode.runAction(monter)
//                print("Commande ok")
//            case 7:
//                sphereNode.runAction(descendre)
//                print("Commande ok")
//
//
//            default:
//                print("Il n'y a aucune commandes")
//            }
//        }
        let moveSequence = SCNAction.sequence(sequences)
        sphereNode.runAction(moveSequence)
        let constraint = SCNLookAtConstraint(target: cubeNode)
        constraint.isGimbalLockEnabled = true
        cameraNode.constraints = [constraint]
        
        
    }

    
    
    
}
/*
0: Decollage
1: Aterrisage
2: Droite
3: Gauche
4: Avancer
5: Reculer
6: Monter
7: Descendre
*/
