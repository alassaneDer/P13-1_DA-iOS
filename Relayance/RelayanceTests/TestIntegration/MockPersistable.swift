//
//  MockPersistable.swift
//  RelayanceTests
//
//  Created by Alassane Der on 10/06/2025.
//

import Foundation
@testable import Relayance

class MockPersistable: Persistable {
    private let fileURL: URL
    private let simlulateFailure: Bool
    
    init(temporaryDirectory: URL, simlulateFailure: Bool = false) {
        self.fileURL = temporaryDirectory.appendingPathComponent("Source.json")
        self.simlulateFailure = simlulateFailure
    }
    
    func load() throws -> [Client] {
        if simlulateFailure {
            throw NSError(domain: "MockPersistence", code: -1, userInfo: [NSLocalizedDescriptionKey: "Simulated load failure"])
        }
        if !FileManager.default.fileExists(atPath: fileURL.path) {
            return []
        }
        let data = try Data(contentsOf: fileURL)
        return try JSONDecoder().decode([Client].self, from: data)
    }
    
    func save(_ clients: [Relayance.Client]) throws {
        if simlulateFailure {
            throw NSError(domain: "MockPersistence", code: -2, userInfo: [NSLocalizedDescriptionKey: "Sumilated save failure"])
        }
        let data = try JSONEncoder().encode(clients)
        try data.write(to: fileURL, options: .atomic)
    }
}
