//
//  PersistenceServiceIntegrationTests.swift
//  RelayanceTests
//
//  Created by Alassane Der on 08/06/2025.
//

import XCTest
@testable import Relayance

final class PersistenceServiceIntegrationTests: XCTestCase {

    var persistence: PersistenceService!
    var testFileURL: URL!
    
    override func setUpWithError() throws {
        persistence = PersistenceService()
        testFileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("Source.json")

        try super.setUpWithError()
        
        /// Clean up test data
        if FileManager.default.fileExists(atPath: testFileURL.path) {
            try FileManager.default.removeItem(at: testFileURL)
        }
    }
    
    override func tearDownWithError() throws {
        /// Clean up test data
        if FileManager.default.fileExists(atPath: testFileURL.path) {
            try FileManager.default.removeItem(at: testFileURL)
        }
    }

    func test_AddClientPersistence() throws {
        /// chargement des clients initiaux
        var clients = try persistence.load()
        let firstCount = clients.count
        
        /// add new client
        let newClient = Client(nom: "integration", email: "test.integration@mail.com", dateCreationString: "01-01-2021")
        clients.append(newClient)
        
        /// save
        try persistence.save(clients)
        
        /// load
        let reloaded = try persistence.load()
        
        /// test
        XCTAssertEqual(reloaded.count, firstCount + 1)
        XCTAssertTrue(reloaded.contains { $0.email == newClient.email})
    }

    func test_DeleteClientPersistence() throws {
        /// chargement des clients initiaux
        var clients = try persistence.load()
        let firstCount = clients.count
        
        /// add new client
        let newClient = Client(nom: "integration", email: "test.integration@mail.com", dateCreationString: "01-01-2021")
        clients.append(newClient)
        
        /// save
        try persistence.save(clients)
        
        /// load
        let reloaded = try persistence.load()
        
        /// test
        XCTAssertEqual(reloaded.count, firstCount + 1)
        XCTAssertTrue(reloaded.contains { $0.email == newClient.email})
    }

}
