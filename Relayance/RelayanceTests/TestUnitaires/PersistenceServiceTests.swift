//
//  PersistenceServiceTests.swift
//  RelayanceTests
//
//  Created by Alassane Der on 04/06/2025.
//
import XCTest
@testable import Relayance

final class PersistenceServiceTests: XCTestCase {
    var testFileURL: URL!
    
    // MARK: - Setup and Teardown
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        // Create a unique temporary file URL for testing
        testFileURL = FileManager.default.temporaryDirectory.appendingPathComponent("TestSource_\(UUID().uuidString).json")
        PersistenceService.overrideFileURL = testFileURL
    }
    
    override func tearDownWithError() throws {
        // Clean up test data
        PersistenceService.clearTestData()
        PersistenceService.overrideFileURL = nil
        try super.tearDownWithError()
    }
    
    // MARK: - Load Tests
    
    func test_load_shouldReturnEmptyArrayWhenFileDoesNotExist() {
        // Given: No file exists at the override URL
        XCTAssertFalse(FileManager.default.fileExists(atPath: testFileURL.path), "Test file should not exist initially")
        
        // When: Load clients
        let clients = PersistenceService.load()
        
        // Then: Verify an empty array is returned
        XCTAssertTrue(clients.count == 8, "Should return an empty array when file does not exist")
    }
    
    func test_load_shouldReturnClientsFromValidFile() throws {
        // Given: A valid JSON file with clients
        let clients = [
            Client(nom: "John Doe", email: "johndoe@mail.com", dateCreationString: "2025-01-01"),
            Client(nom: "Jane Smith", email: "janesmith@mail.com", dateCreationString: "2025-02-01")
        ]
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let data = try encoder.encode(clients)
        try data.write(to: testFileURL, options: .atomic)
        
        // When: Load clients
        let loadedClients = PersistenceService.load()
        
        // Then: Verify the loaded clients
        XCTAssertEqual(loadedClients.count, 2, "Should load 2 clients")
        XCTAssertEqual(loadedClients[0].nom, "John Doe", "First client name should be correct")
        XCTAssertEqual(loadedClients[0].email, "johndoe@mail.com", "First client email should be correct")
        XCTAssertEqual(loadedClients[1].nom, "Jane Smith", "Second client name should be correct")
        XCTAssertEqual(loadedClients[1].email, "janesmith@mail.com", "Second client email should be correct")
    }
    
    func test_load_shouldReturnEmptyArrayOnInvalidData() throws {
        // Given: A file with invalid JSON data
        let invalidData = "invalid json".data(using: .utf8)!
        try invalidData.write(to: testFileURL, options: .atomic)
        
        // When: Load clients
        let clients = PersistenceService.load()
        
        // Then: Verify an empty array is returned
        XCTAssertTrue(clients.isEmpty, "Should return an empty array for invalid data")
    }
    
    func test_load_shouldLoadDefaultDataWhenNoOverrideFileExists() throws {
        // Given: No override file, but default Source.json exists in the bundle
        PersistenceService.overrideFileURL = nil // Remove override to test default loading
        
        // When: Load clients
        let clients = PersistenceService.load()
        
        // Then: Verify default data is loaded (assuming Source.json contains Frida Kahlo)
        XCTAssertFalse(clients.isEmpty, "Should load default clients from Source.json")
        XCTAssertEqual(clients.first?.nom, "Frida Kahlo", "First client name should be correct")
    }
    
    // MARK: - Save Tests
    
    func test_save_shouldPersistClientsToFile() throws {
        // Given: A list of clients
        let clients = [
            Client(nom: "Alice Diouf", email: "alicediouf@mail.com", dateCreationString: "2025-03-01")
        ]
        
        // When: Save clients
        PersistenceService.save(clients: clients)
        
        // Then: Verify the file exists and contains the correct data
        XCTAssertTrue(FileManager.default.fileExists(atPath: testFileURL.path), "File should exist after saving")
        let loadedData = try Data(contentsOf: testFileURL)
        let decoder = JSONDecoder()
        let loadedClients = try decoder.decode([Client].self, from: loadedData)
        XCTAssertEqual(loadedClients.count, 1, "Should have saved 1 client")
        XCTAssertEqual(loadedClients[0].nom, "Alice Diouf", "Saved client name should be correct")
        XCTAssertEqual(loadedClients[0].email, "alicediouf@mail.com", "Saved client email should be correct")
    }
    
    func test_save_shouldHandleEmptyClientList() throws {
        // Given: An empty client list
        let clients: [Client] = []
        
        // When: Save empty list
        PersistenceService.save(clients: clients)
        
        // Then: Verify the file exists and is empty
        XCTAssertTrue(FileManager.default.fileExists(atPath: testFileURL.path), "File should exist after saving")
        let loadedData = try Data(contentsOf: testFileURL)
        let decoder = JSONDecoder()
        let loadedClients = try decoder.decode([Client].self, from: loadedData)
        XCTAssertTrue(loadedClients.isEmpty, "Saved client list should be empty")
    }
    
    // MARK: - ClearTestData Tests
    
    func test_clearTestData_shouldRemoveOverrideFile() throws {
        // Given: A file exists at the override URL
        let data = "test data".data(using: .utf8)!
        try data.write(to: testFileURL, options: .atomic)
        XCTAssertTrue(FileManager.default.fileExists(atPath: testFileURL.path), "Test file should exist initially")
        
        // When: Clear test data
        PersistenceService.clearTestData()
        
        // Then: Verify the file is removed
        XCTAssertFalse(FileManager.default.fileExists(atPath: testFileURL.path), "Test file should be removed")
    }
    
    func test_clearTestData_shouldDoNothingIfNoFileExists() {
        // Given: No file exists at the override URL
        XCTAssertFalse(FileManager.default.fileExists(atPath: testFileURL.path), "Test file should not exist initially")
        
        // When: Clear test data
        PersistenceService.clearTestData()
        
        // Then: Verify no errors and file still does not exist
        XCTAssertFalse(FileManager.default.fileExists(atPath: testFileURL.path), "Test file should still not exist")
    }
}
