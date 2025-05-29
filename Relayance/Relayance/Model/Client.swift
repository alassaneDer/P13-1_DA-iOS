//
//  Model.swift
//  Relayance
//
//  Created by Amandine Cousin on 10/07/2024.
//

import Foundation

struct Client: Codable, Hashable, Identifiable {
    let id = UUID()
    var nom: String
    var email: String
    var dateCreationString: String
    
    var dateCreation: Date {
        Date.dateFromString(dateCreationString) ?? Date.now
    }
    
    enum CodingKeys: String, CodingKey {
        case nom, email
        case dateCreationString = "date_creation"
    }
    
    /// Constructeur explicite pour créer une nouvelle instance de Client en code.
    init(nom: String, email: String, dateCreationString: String) {
        self.nom = nom
        self.email = email
        self.dateCreationString = dateCreationString
    }
}
