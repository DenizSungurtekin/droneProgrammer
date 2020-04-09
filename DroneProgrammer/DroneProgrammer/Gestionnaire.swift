//
//  Gestionnaire.swift
//  DroneProgrammer
//
//  Created by dede on 02.04.20.
//  Copyright © 2020 CUI. All rights reserved.
//


import Foundation
import UIKit

class Gestionnaire: UIViewController, UITableViewDelegate, UITableViewDataSource {
 
    @IBOutlet weak var searchBar: UISearchBar!;
    @IBOutlet weak var tableView: UITableView!;
    
    var files = [Fichier]();
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        
        downloadJSON {
            self.tableView.reloadData()
        }
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return files.count
     }
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = files[indexPath.row].nom.capitalized
        return cell
     }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {

        if editingStyle == .delete {
            
            let selectedCell = indexPath.row;
            //print(name as Any)
            
            //Prepare for re-writing file
            let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
            let url = NSURL(fileURLWithPath: path)
            
            let fileManager = FileManager.default
            
            if url.appendingPathComponent("flight_plan.json") != nil{
                //let filePath = pathComponent.path
                    
                do {
                    let url = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false);
                    
                    let jsonURL = url.appendingPathComponent("flight_plan.json");
                    print(jsonURL)
                    var jsonData = try Data(contentsOf: jsonURL)
                    let files = try JSONDecoder().decode([Fichier].self, from: jsonData) // On lit tout les fichiers présents dans le JSON afin de pouvoir les              réecrire (Obligation lié au format JSON)
                    var topLevel: [AnyObject] = [];
                    var counter: Int = 0;
                    // On ajoute les fichiers déjà présent dans le JSON
                    for singlefile in files {
                        var fileDictionnary : [String : AnyObject] = [:];
                        let nameInJson = singlefile.nom as AnyObject;
                        print("nom en json: \(nameInJson)")
                        //print("nom de la cellule: \(selectedname)")
                        if counter == selectedCell {
                            print("Break")
                            counter += 1;
                            continue;
                            
                        }
                        fileDictionnary["nom"] = nameInJson;
                        fileDictionnary["ListeCommande"] = singlefile.listeCommande as AnyObject;
                        fileDictionnary["ListeObstacle"] = singlefile.listeObstacle as AnyObject;
                        topLevel.append(fileDictionnary as AnyObject);
                        counter += 1;
                        }
                    jsonData = try JSONSerialization.data(withJSONObject: topLevel, options: .prettyPrinted);
                    try jsonData.write(to: jsonURL);
                    }
                    
                catch{
                    print(error)
                }
            }
            
            // delete the table view row
            print("delete Row")
            files.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)

        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "loadPlan", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? PlanDeVolVC{
            destination.sauvegarde = files[(tableView.indexPathForSelectedRow?.row)!]
        }
    }

    
    func downloadJSON(completed: @escaping () -> ()) {
        
               do {
                let fileManager = FileManager.default;
                let url = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false);
                let jsonURL = url.appendingPathComponent("flight_plan.json");
                let jsonData = try Data(contentsOf: jsonURL);
                self.files = try JSONDecoder().decode([Fichier].self, from: jsonData); // On lit toute les sauvegardes
                   
                   DispatchQueue.main.async {
                       completed()
                   }
                                 
           }
               catch{
                   print(error)
               }
        
    
    }
}
