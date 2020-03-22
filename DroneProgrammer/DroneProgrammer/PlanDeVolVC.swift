//
//  PlanDeVolVC.swift
//  DroneProgrammer
//
//  Created by Mathias Tonini on 22.03.20.
//  Copyright © 2020 CUI. All rights reserved.
//

import Foundation
import UIKit
class Obstacle{
    
    var posX :Int;
    var posY :Int;
    var posZ: Int;
    
    init(x: Int, y:Int, z: Int){
        self.posX = x;
        self.posY = y;
        self.posZ = z;
    }
    
    
}

class PlanDeVolVC: UIViewController, UIAlertViewDelegate {
   //Eléments de la view
    
    @IBOutlet var coordoEntryX: UITextField!;
    @IBOutlet var coordoEntryY: UITextField!;
    @IBOutlet var coordoEntryZ: UITextField!;
    
    var listeCommande :[Int] = [];
    /*  0---> Décollage
        1---> Attérissage
        2---> Droite
        3---> Gauche
        4---> Avancer
        5---> Reculer
        6---> monter
        7---> Descendre
     */
    var listeObstacle :[Obstacle] = [];
    
    @IBAction func decollageAppuyer(_ sender: Any) {
        listeCommande.insert(0, at: <#Int#>);
    }
    @IBAction func aterissageAppuyer(_sender: Any ) {
        listeCommande.insert(1, at: <#Int#>);
    }
    @IBAction func droiteAppuyer(_sender: Any) {
        listeCommande.insert(2, at: <#Int#>)
    }
    @IBAction func gaucheAppuyer(_sender: Any) {
        listeCommande.insert(3, at: <#T##Int#>)
    }
    @IBAction func appuyerForward(_sender: Any){
        listeCommande.insert(4, at: <#Int#>)
    }
    @IBAction func appuyerBack(_sender: Any){
        listeCommande.insert(5, at: <#Int#>)
    }
    @IBAction func hautAppuyer(_sender: Any){
        listeCommande.insert(6, at: <#T##Int#>)
    }
    @IBAction func basAppuyer(_sender: Any){
        listeCommande.insert(7, at: <#T##Int#>)
    }
    
    
    

    
    
    
    
    
    
    
    
}
