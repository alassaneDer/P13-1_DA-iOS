//
//  PersistenceService.swift
//  Relayance
//
//  Created by Alassane Der on 29/05/2025.
//

import Foundation

protocol Persistable {
    func load() throws -> [Client]
    func save(_ clients: [Client]) throws
}

class PersistenceService: Persistable {
    
    private let fileName = "Source.json"
    
    private var fileURL: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(fileName)
    }
    
    private var urlBundle: URL? {
        Bundle.main.url(forResource: "Source", withExtension: "json")
    }
    
    func load() throws -> [Client] {
        let fileURL = fileURL
        
        if !FileManager.default.fileExists(atPath: fileURL.path) {
            guard let bundleURL = urlBundle else {
                throw NSError(domain: "No JSON file in the bundle", code: 1)
            }
            
            let data = try Data(contentsOf: bundleURL)
            let elements = try JSONDecoder().decode([Client].self, from: data)
            
            try save(elements)
            return elements
        }
        
        let data = try Data(contentsOf: fileURL)
        return try JSONDecoder().decode([Client].self, from: data)
        
    }
    
    func save(_ clients: [Client]) throws {
        let data = try JSONEncoder().encode(clients)
        try data.write(to: fileURL, options: .atomic)
    }
    
}
