//
//  comandeListeView.swift
//  DroneProgrammer
//
//  Created by Mathias Tonini on 30.03.20.
//  Copyright © 2020 CUI. All rights reserved.
//

import UIKit
class commandeListeView: UITableView {

    // Data model: These strings will be the data for the table view cells
    var cmd: [Int] = [];
    let dict: [String] = ["Décollage", "Attérissage","Droite","Gauche","Avancer","Reculer","Monter","Descendre"]

    // cell reuse id (cells that scroll out of view can be reused)
    
    // don't forget to hook this up from the storyboard
    //@IBOutlet var tableView: UITableView!
    
    
    let cellReuseIdentifier = "cell"
  
    func update(instr: Int)
    {
        
        
    }
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cmd.count
    }

    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // create a new cell if needed or reuse an old one
        let cell:UITableViewCell = self.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell!

        // set the text from the data model
        cell.textLabel?.text = self.dict[self.cmd[indexPath.row]];

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
            self.cmd.remove(at: indexPath.row)

            // delete the table view row
            tableView.deleteRows(at: [indexPath], with: .fade)

        } else if editingStyle == .insert {
            // Not used in our example, but if you were adding a new row, this is where you would do it.
        }
    }
}
