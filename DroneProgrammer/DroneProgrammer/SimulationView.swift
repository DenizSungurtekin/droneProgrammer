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
        for el in obstacles {
            print (el.write())
        }
        print(commandes)
        

    }
   

    
    
    
}
