//
//  MockPersistence.swift
//  RelayanceTests
//
//  Created by Alassane Der on 08/06/2025.
//

@testable import Relayance

class MockPersistence: Persistable {
    var saved: [Client] = []
    var savedCalled = false
    
    func load() throws -> [Client] {
        return saved
    }
    
    func save(_ clients: [Client]) throws {
        saved = clients
        savedCalled = true
    }
}
