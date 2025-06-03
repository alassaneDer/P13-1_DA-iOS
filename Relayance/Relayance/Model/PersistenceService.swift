//
//  PersistenceService.swift
//  Relayance
//
//  Created by Alassane Der on 29/05/2025.
//

import Foundation

class PersistenceService {
    /// URL du fichier dans le document de l'app
    static var overrideFileURL: URL?
    
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
    
    static var activeFileURL: URL {
        return overrideFileURL ?? documentsFolderURL.appendingPathComponent("Source.json")
    }
    
    static func load() -> [Client] {
        let urlToLoad = activeFileURL
        if FileManager.default.fileExists(atPath: urlToLoad.path) {
            do {
                let data = try Data(contentsOf: urlToLoad)
                let decoder = JSONDecoder()
                return try decoder.decode([Client].self, from: data)
            } catch {
                if overrideFileURL != nil {
                    return []
                }
            }
        }
        return ModelData.chargement("Source.json")
    }
    static func save(clients: [Client]) {
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let data = try encoder.encode(clients)
            try data.write(to: activeFileURL, options: .atomic)
        } catch {
            print("Impossible de sauvegarder les clients dans le fichier: \(error)")
        }
    }
    
    
    /// methode utilitaire pour nettoyer le fichier de test
    static func clearTestData() {
        if let testURL = overrideFileURL, FileManager.default.fileExists(atPath: testURL.path) {
            try? FileManager.default.removeItem(at: testURL)
        }
    }
}
