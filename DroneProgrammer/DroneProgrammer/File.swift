//
//  File.swift
//  DroneProgrammer
//
//  Created by dede on 31.03.20.
//  Copyright © 2020 CUI. All rights reserved.
//

import Foundation

// Structure pour écrire un fichier Json
struct File: Decodable{
    var name :String;
    var listeCommande :[Int] = [];
    var liste :[[Int]] = [];
    var liste2 :[[Int]] = [];
    
    init(name: String, listeCommande: [Int], liste: [[Int]], liste2: [[Int]]){
        self.name = name;
        self.listeCommande = listeCommande;
        self.liste = liste;
        self.liste2 = liste2;
    }
}

// Structure pour lire un fichier Json
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




