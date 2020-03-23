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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Commande");
        tableView.delegate = self as! UITableViewDelegate;
        tableView.dataSource = self as! UITableViewDataSource;
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listeCommande.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

           // create a new cell if needed or reuse an old one
           let cell:UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "Commande") as UITableViewCell!

           // set the text from the data model
           cell.textLabel?.text = self.cmd[listeCommande[indexPath.row]]

           return cell
    }

       // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           print("You tapped cell number \(indexPath.row).")
    }
    
    // this method handles row deletion
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {

        if editingStyle == .delete {

            // remove the item from the data model
            listeCommande.remove(at: indexPath.row)

            // delete the table view row
            tableView.deleteRows(at: [indexPath], with: .fade)

        } else if editingStyle == .insert {
            // Not used in our example, but if you were adding a new row, this is where you would do it.
        }
    }
    
     override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
    
}
