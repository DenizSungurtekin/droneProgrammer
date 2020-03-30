//
//  PlanDeVolVC.swift
//  DroneProgrammer
//
//  Created by Mathias Tonini on 22.03.20.
//  Copyright © 2020 CUI. All rights reserved.
//

import Foundation
import UIKit

class PlanDeVolVC: UIViewController, UIAlertViewDelegate {
    // UI nécessaire
    var errorAlertView: UIAlertController?
    
   //Eléments de la view
    
    @IBOutlet var posXentree: UITextField!;
    @IBOutlet var posYentree: UITextField!;
    @IBOutlet var posZentree: UITextField!;
    
    //Table View
    @IBOutlet var tableView: UITableView!;
    
    
    let cmd = ["Décollage","Attérissage","Droite","Gauche","Avancer","Reculer","Monter","Descendre"]
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
    var tmpCmd: [Int] = [];
    var tmpObs: [Obstacle] = [];
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if tmpCmd.count != 0 {
            listeCommande = tmpCmd;
        }
        if tmpObs.count != 0 {
            listeObstacle = tmpObs;
        }
    }
     override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toHistory"{
            //Get SecondViewVC
            let controller = segue.destination as! commandeListeView;
            //Set message to SecondViewVC
            controller.listeCommande = self.listeCommande;
        }
        else if segue.identifier == "toObstacle"{
            let viewObstacle = segue.destination as! ObstacleListeView;
            /*for el in self.listeObstacle{
                print (el.write());
            }*/
            viewObstacle.listeObstacle = self.listeObstacle;
        }
    }
    
    //Nécessaire pour la position des obstacles et éventullement arguments des commandes
    func isStringAnInt(string: String) -> Bool {
        // test if the string is an integer
        return Int(string) != nil
    }
    @IBAction func decollageAppuyer(_ sender: Any) {
        listeCommande.insert(0, at: listeCommande.endIndex);
    }
    @IBAction func aterissageAppuyer(_sender: Any ) {
        listeCommande.insert(1, at: listeCommande.endIndex);
    }
    @IBAction func droiteAppuyer(_sender: Any) {
        listeCommande.insert(2, at: listeCommande.endIndex)
    }
    @IBAction func gaucheAppuyer(_sender: Any) {
        listeCommande.insert(3, at: listeCommande.endIndex)
    }
    @IBAction func appuyerForward(_sender: Any){
        listeCommande.insert(4, at: listeCommande.endIndex)
    }
    @IBAction func appuyerBack(_sender: Any){
        listeCommande.insert(5, at: listeCommande.endIndex)
    }
    @IBAction func hautAppuyer(_sender: Any){
        listeCommande.insert(6, at: listeCommande.endIndex)
    }
    @IBAction func basAppuyer(_sender: Any){
        listeCommande.insert(7, at: listeCommande.endIndex)
    }
    @IBAction func addObstalcle(_sender: Any){
        
        if (isStringAnInt(string: posXentree.text!) && isStringAnInt(string: posYentree.text!) && isStringAnInt(string: posZentree.text!)){
            let posX = (posXentree.text! as NSString).integerValue;
            let posY = (posYentree.text! as NSString).integerValue;
            let posZ = (posZentree.text! as NSString).integerValue;
            let obs = Obstacle.init(x: posX, y: posY, z: posZ);
            //print (obs.write());
            listeObstacle.insert(obs, at: listeObstacle.endIndex);
            
        }
        else {
            errorAlertView = UIAlertController(
                title: "Error in coordonate input",
                message: "Please enter a number",
                preferredStyle: .alert)
            errorAlertView?.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(errorAlertView!, animated: true, completion: nil)
        }
        
    }
    @IBAction func save(_sender: Any){
        /*
                    TO DO
         */
    }
    @IBAction func test(_sender: Any){
        for el in listeCommande{
            print (el);
        }
        for el in listeObstacle{
            print(el.write());
        }
    }
    
}
