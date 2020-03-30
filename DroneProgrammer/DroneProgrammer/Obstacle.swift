//
//  Obstacle.swift
//  DroneProgrammer
//
//  Created by Mathias Tonini on 30.03.20.
//  Copyright © 2020 CUI. All rights reserved.
//

import Foundation
class Obstacle{
    
    var posX :Int;
    var posY :Int;
    var posZ: Int;
    
    init(x: Int, y:Int, z: Int){
        self.posX = x;
        self.posY = y;
        self.posZ = z;
    }
    func write() -> String {
        return "X position \(posX) ; Y position \(posY) ; Z position \(posZ)"
    }
    
}
