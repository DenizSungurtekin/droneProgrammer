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
        print(files.count)
        return files.count
     }
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = files[indexPath.row].nom.capitalized
        return cell
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
                let jsonURL = url.appendingPathComponent("Plan_de_Vol.json");
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
