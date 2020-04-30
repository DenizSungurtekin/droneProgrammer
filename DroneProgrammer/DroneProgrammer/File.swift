//
//  File.swift
//  DroneProgrammer
//
//  Created by dede on 31.03.20.
//  Copyright © 2020 CUI. All rights reserved.
//

import Foundation

struct File: Decodable{
    var name :String;
    var listeCommande :[Int] = [];
    //var listeObstacle :[Int] = [];
    var liste :[[Int]] = [];
    var liste2 :[[Int]] = [];
    
    
    init(name: String, listeCommande: [Int], liste: [[Int]], liste2: [[Int]]){
        self.name = name;
        self.listeCommande = listeCommande;
        //self.listeObstacle = listeObstacle;
        self.liste = liste;
        self.liste2 = liste2;
        
    }
}

struct Fichier: Decodable {
    let listeCommande: [Int]
    let listeObstacle: [[Int]]
    let listeObjectif: [[Int]]
    let nom: String

    enum CodingKeys: String, CodingKey {
        case listeCommande = "ListeCommande"
        case listeObstacle = "ListeObstacle"
        case listeObjectif = "ListeObjectif"
        case nom
    }
}
//init(name: String, listeCommande: [Int], liste: [[Int]])



