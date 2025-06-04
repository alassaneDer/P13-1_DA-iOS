//
//  PersistenceService.swift
//  Relayance
//
//  Created by Alassane Der on 29/05/2025.
//

import Foundation

class PersistenceService {
    /// optional override URL for testing purpose
    static var overrideFileURL: URL?
    
    /// URL of the app's document directory
    private static var documentsFolderURL: URL {
        do {
            return try FileManager.default.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true
            )
        } catch {
            fatalError("Failed to access to document directory: \(error).")
        }
    }
    
    /// Active file URL, either the override or the default Source.json in documents
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
                print("Failed to load clients from \(urlToLoad): \(error)")
                if overrideFileURL != nil {
                    return []
                }
            }
        }
        do {
            return try ModelData.chargement("Source")
        } catch {
            print("Failed to load defaul clients: \(error)")
            return []
        }
    }
    
    
    static func save(clients: [Client]) {
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let data = try encoder.encode(clients)
            try data.write(to: activeFileURL, options: .atomic)
        } catch {
            print("Failed to save clients to \(activeFileURL): \(error)")
        }
    }
    
    
    /// clear test data by removing the override file
    static func clearTestData() {
        if let testURL = overrideFileURL, FileManager.default.fileExists(atPath: testURL.path) {
            try? FileManager.default.removeItem(at: testURL)
        }
    }
}
