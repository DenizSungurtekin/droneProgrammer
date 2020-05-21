//
//  Objectif.swift
//  DroneProgrammer
//
//  Created by dede on 30.04.20.
//  Copyright © 2020 CUI. All rights reserved.
//

import Foundation
class Objectif: Decodable {
    
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
    func toJson() -> [Int] {
        return [self.posX,self.posY,self.posZ]
    }
    //Function "equals"
    static func ==(lhs: Objectif, rhs: Objectif) -> Bool {
        return lhs.posX == rhs.posX && lhs.posY == rhs.posY && lhs.posZ == rhs.posZ
    }
    
    
}
