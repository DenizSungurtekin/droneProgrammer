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
    
    init(name: String, listeCommande: [Int]){
        self.name = name;
        self.listeCommande = listeCommande;
    }
}

struct Fichier : Decodable {
    let nom: String
    let listeCommande: [Int]
    
    enum CodingKeys: String, CodingKey {
    case nom
    case listeCommande = "ListeCommande"
    }
}



