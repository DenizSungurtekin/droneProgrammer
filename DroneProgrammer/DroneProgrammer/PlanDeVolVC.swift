//
//  PlanDeVolVC.swift
//  DroneProgrammer
//
//  Created by Mathias Tonini on 22.03.20.
//  Copyright © 2020 CUI. All rights reserved.
//
import Foundation
import UIKit

class PlanDeVolVC: UIViewController, UIAlertViewDelegate, UITableViewDelegate, UITableViewDataSource{
    
    
    
    
    // UI nécessaire
    var errorAlertView: UIAlertController?
    
   //Eléments de la view
    
    @IBOutlet var NomPlan: UITextField!
    @IBOutlet var posXentree: UITextField!;
    @IBOutlet var posYentree: UITextField!;
    @IBOutlet var posZentree: UITextField!;
    
    //Table View
    
    @IBOutlet var tableView: UITableView!
    
    var sauvegarde:Fichier
    
    required init?(coder aDecoder: NSCoder) {
        sauvegarde = Fichier.init(listeCommande: listeCommande,listeObstacle: [[1,2]], nom: "SauvegardeParDefault");
        
        super.init(coder: aDecoder)
        
    }
    
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
    
    let cellReuseIdentifier = "cell";
    var obstacleListe : [[Int]] = [];
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if sauvegarde.listeCommande.count != 0{
            listeCommande = sauvegarde.listeCommande
            obstacleListe = sauvegarde.listeObstacle
            for element in obstacleListe {
                tmpObs.append(Obstacle.init(x: element[0], y: element[1], z: element[2]))
            }
        }
        
        if tmpCmd.count != 0 {
            listeCommande = tmpCmd;
            
            
        }
        if tmpObs.count != 0 {
            listeObstacle = tmpObs;
        }
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier);
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
    }
     override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Cas ou la liste est vide on ne peut pas lancer la simulation
        if listeCommande.count == 0  {
            errorAlertView = UIAlertController(
                title: "La liste de commande est erronée",
                message: "Veuillez vous s'assurer que la liste ne soit pas vide",
                preferredStyle: .alert)
            errorAlertView?.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(errorAlertView!, animated: true, completion: nil)
            
        }
            
        else {
        if segue.identifier == "toSimulation"{
            let simulationView = segue.destination as! SimulationView;
            simulationView.tmpObs = self.listeObstacle;
            simulationView.tmpCmd = self.listeCommande;
            
                }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let data = [listeCommande.count, listeObstacle.count]
        return data[section]
    }
    

    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // create a new cell if needed or reuse an old one
        let cell:UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell!
        

        // set the text from the data model
        if indexPath.section == 0{
            cell.textLabel?.text = self.cmd[self.listeCommande[indexPath.row]];
        }else if  indexPath.section == 1{
            cell.textLabel?.text = self.listeObstacle[indexPath.row].write();
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Commandes"
        }else{
           
            return "Obstacles"
        }
    }


    // this method handles row deletion
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {

        if editingStyle == .delete {

            // remove the item from the data model
            if indexPath.section == 0{
                self.listeCommande.remove(at: indexPath.row)
            }else if indexPath.section == 1{
                self.listeObstacle.remove(at: indexPath.row);
            }

            // delete the table view row
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
    }
    
    func updateTableView(){
        tableView.beginUpdates()
        tableView.insertRows(at: [IndexPath(row: self.listeCommande.count-1, section: 0)], with: .automatic)
        tableView.endUpdates()
    }
    //Nécessaire pour la position des obstacles et éventullement arguments des commandes
    func isStringAnInt(string: String) -> Bool {
        // test if the string is an integer
        return Int(string) != nil
    }
    @IBAction func decollageAppuyer(_ sender: Any) {
        listeCommande.insert(0, at: listeCommande.endIndex);
        updateTableView()
    }
    @IBAction func aterissageAppuyer(_sender: Any ) {
        listeCommande.insert(1, at: listeCommande.endIndex);
      updateTableView()
    }
    @IBAction func droiteAppuyer(_sender: Any) {
        listeCommande.insert(2, at: listeCommande.endIndex)
        updateTableView()
    }
    @IBAction func gaucheAppuyer(_sender: Any) {
        listeCommande.insert(3, at: listeCommande.endIndex)
        updateTableView()
    }
    @IBAction func appuyerForward(_sender: Any){
        listeCommande.insert(4, at: listeCommande.endIndex);
        updateTableView()
    }
    @IBAction func appuyerBack(_sender: Any){
        listeCommande.insert(5, at: listeCommande.endIndex)
        updateTableView()
    }
    @IBAction func hautAppuyer(_sender: Any){
        listeCommande.insert(6, at: listeCommande.endIndex)
        updateTableView()
    }
    @IBAction func basAppuyer(_sender: Any){
        listeCommande.insert(7, at: listeCommande.endIndex)
        updateTableView()
    }
    @IBAction func addObstalcle(_sender: Any){
        
        // On s'assure que les obstacles ne soit pas hors de notre cube de simulation
        if (posXentree.text! as NSString).integerValue < -10 || (posXentree.text! as NSString).integerValue > 10 || (posYentree.text! as NSString).integerValue < -10 || (posYentree.text! as NSString).integerValue > 10 || (posZentree.text! as NSString).integerValue < -10 || (posZentree.text! as NSString).integerValue > 10 {
            errorAlertView = UIAlertController(
                title: "Obstacle hors du champ de la simulation",
                message: "Veuillez entrer des valeurs entre -10 et 10",
                preferredStyle: .alert)
            errorAlertView?.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(errorAlertView!, animated: true, completion: nil)
            
        }
        else {
        if (isStringAnInt(string: posXentree.text!) && isStringAnInt(string: posYentree.text!) && isStringAnInt(string: posZentree.text!)){
            let posX = (posXentree.text! as NSString).integerValue;
            let posY = (posYentree.text! as NSString).integerValue;
            let posZ = (posZentree.text! as NSString).integerValue;
            let obs = Obstacle.init(x: posX, y: posY, z: posZ);
            listeObstacle.insert(obs, at: listeObstacle.endIndex);
            
            tableView.beginUpdates()
            tableView.insertRows(at: [IndexPath(row: self.listeObstacle.count-1, section: 1)], with: .automatic)
            tableView.endUpdates()
            
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
}
    @IBAction func cleanCommand (_sender: Any){
        
        let size = self.listeCommande.count-1
        if size >= 0{
            while self.listeCommande.count > 0 {
                self.listeCommande.remove(at: 0)
                let pos: IndexPath = [0,0]
                self.tableView.deleteRows(at: [pos], with:.fade)
            }
        }else{
            errorAlertView = UIAlertController(
                title: "Can't delete command",
                message: "Please enter at least one command",
                preferredStyle: .alert)
            errorAlertView?.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(errorAlertView!, animated: true, completion: nil)
        }
    }
    @IBAction func save(_sender: Any){
        
        // Chemin du dossier PlanVol lié au projet (Seul endroit où l'on peut écrire un fichier)
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let url = NSURL(fileURLWithPath: path)
        
        if let pathComponent = url.appendingPathComponent("flight_plan.json"){
            let filePath = pathComponent.path
            let fileManager = FileManager.default
            // Vérifie si le fichier existe
            if fileManager.fileExists(atPath: filePath) {
                
                // Cas ou un fichier existe déja
                do {
                    var url = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false);
                    var jsonURL = url.appendingPathComponent("flight_plan.json");
                    var jsonData = try Data(contentsOf: jsonURL)
                    let files = try JSONDecoder().decode([Fichier].self, from: jsonData) // On lit tout les fichiers présents dans le JSON afin de pouvoir les              réecrire (Obligation lié au format JSON)
                    var topLevel: [AnyObject] = [];
                    
                    // On ajoute les fichiers déjà présent dans le JSON
                    for singlefile in files {
                        var fileDictionnary : [String : AnyObject] = [:];
                        
                        fileDictionnary["nom"] = singlefile.nom as AnyObject;
                        fileDictionnary["ListeCommande"] = singlefile.listeCommande as AnyObject;
                        fileDictionnary["ListeObstacle"] = singlefile.listeObstacle as AnyObject;
                        topLevel.append(fileDictionnary as AnyObject);

                    }
                    
                    // On ajoute le fichier ajouté
                    var fileDictionnary : [String : AnyObject] = [:];
                    let nomFichierTest = NomPlan.text!;
                    
                    var liste: [[Int]] = []
                    for element in listeObstacle {
                        liste.append(element.toJson())
                    }
                    
                    let fichier = File.init(name: nomFichierTest, listeCommande: listeCommande, liste: liste);
                    fileDictionnary["nom"] = fichier.name as AnyObject;
                    fileDictionnary["ListeCommande"] = fichier.listeCommande as AnyObject;
                    fileDictionnary["ListeObstacle"] = fichier.liste as AnyObject;
                    topLevel.append(fileDictionnary as AnyObject);
                    jsonData = try JSONSerialization.data(withJSONObject: topLevel, options: .prettyPrinted);
                       
                    let fileManager = FileManager.default;
                    url = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false);
                    jsonURL = url.appendingPathComponent("flight_plan.json");
                    print(jsonURL)
                    try jsonData.write(to: jsonURL); // On encode sous le format JSON la totalité des fichiers
                    
                } catch {
                    print(error)
                }
                
            } else {
                
                var liste: [[Int]] = []
                for element in listeObstacle {
                    liste.append(element.toJson())
                }
                // Cas ou le fichier n'existe pas (Première sauvegarde)
                let nomFichierTest = NomPlan.text!;
                let fichier = File.init(name: nomFichierTest, listeCommande: listeCommande, liste: liste);
                var topLevel: [AnyObject] = []
                var fileDictionnary : [String : AnyObject] = [:];
                fileDictionnary["nom"] = fichier.name as AnyObject;
                fileDictionnary["ListeCommande"] = fichier.listeCommande as AnyObject;
                fileDictionnary["ListeObstacle"] = fichier.liste as AnyObject;
                topLevel.append(fileDictionnary as AnyObject);
                
                 do {
                    let jsonData = try JSONSerialization.data(withJSONObject: topLevel, options: .prettyPrinted);
                    let fileManager = FileManager.default;
                    let url = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false);
                    let jsonURL = url.appendingPathComponent("flight_plan.json"); // URL du fichier JSON
                    print(jsonURL)
                    try jsonData.write(to: jsonURL);
        
                 } catch {
                     print(error)
                 }
            }
        }
    }
}
