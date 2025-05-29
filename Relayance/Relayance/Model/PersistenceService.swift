//
//  PersistenceService.swift
//  Relayance
//
//  Created by Alassane Der on 29/05/2025.
//

import Foundation

class PersistenceService {
    /// URL du fichier dans le document de l'app
    private static var documentsFolderURL: URL {
        do {
            return try FileManager.default.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: false
            )
        } catch {
            fatalError("Impossible de trouver le dossier document.")
        }
    }
    
    private static var fileURL: URL {
        return documentsFolderURL.appendingPathComponent("Source.json")
    }
    
    /// chargement des clients : tentative d'abord depuis le dossier Document
    /// si échec, chargement depuis le bundle de l'app
    static func load() -> [Client] {
        /// tentative chargement depuis le dossier Document
        if let data = try? Data(contentsOf: fileURL) {
            do {
                let decoder = JSONDecoder()
                return try decoder.decode([Client].self, from: data)
            } catch {
                print("impossible de décoder le fichier Source.json du dossier Documents: \(error)")
            }
        }
        
        /// en cas echec: chargement depuis le bundle
        return ModelData.chargement("Source.json")
    }
    
    static func save(clients: [Client]) {
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let data = try encoder.encode(clients)
            try data.write(to: fileURL, options: .atomic)
        } catch {
            print("Impossible de sauvegarder les clients dans le fichier: \(error)")
        }
    }
}
///Ce service va gérer la lecture et l'écriture du fichier JSON au bon endroit
///J'utilise le dossier Documents de l'application :
///Ce dossier est privé à l'application et accessible en lecture/écriture.
