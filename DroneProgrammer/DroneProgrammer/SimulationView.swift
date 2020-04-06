//
//  SimulationView.swift
//  DroneProgrammer
//
//  Created by Mathias Tonini on 03.04.20.
//  Copyright © 2020 CUI. All rights reserved.
//

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
        commandes = tmpCmd;
        obstacles = tmpObs;
        prepareScence()
        
    }
    func prepareScence(){
        let sceneView = SCNView(frame: self.view.frame)
        self.view.addSubview(sceneView)
        sceneView.autoenablesDefaultLighting = true
        sceneView.allowsCameraControl = true
            
        let scene = SCNScene()
        sceneView.scene = scene

        let camera = SCNCamera()
        let cameraNode = SCNNode()
        cameraNode.camera = camera
        cameraNode.position = SCNVector3(x: -3.0, y: 3.0, z: 1.0)

        let cubeGeometry = SCNBox(width: 3.0, height: 3.0, length: 3.0, chamferRadius: 0.0)
        let cubeNode = SCNNode(geometry: cubeGeometry)
        cubeGeometry.firstMaterial?.diffuse.contents = UIColor.lightGray

        scene.rootNode.addChildNode(cameraNode)
        scene.rootNode.addChildNode(cubeNode)
        let constraint = SCNLookAtConstraint(target: cubeNode)
        constraint.isGimbalLockEnabled = true
        cameraNode.constraints = [constraint]
    }

    
    
    
}
