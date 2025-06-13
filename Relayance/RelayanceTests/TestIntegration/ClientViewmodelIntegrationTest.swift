//
//  ClientViewmodelIntegrationTest.swift
//  RelayanceTests
//
//  Created by Alassane Der on 10/06/2025.
//

import XCTest
@testable import Relayance // Replace with your module name

// Mock Persistable for testing file operations in a temporary directory
class MockPersistenceService: Persistable {
    private let fileURL: URL
    private let simulateFailure: Bool
    
    init(temporaryDirectory: URL, simulateFailure: Bool = false) {
        self.fileURL = temporaryDirectory.appendingPathComponent("Source.json")
        self.simulateFailure = simulateFailure
    }
    
    func load() throws -> [Client] {
        if simulateFailure {
            throw NSError(domain: "MockPersistence", code: -1, userInfo: [NSLocalizedDescriptionKey: "Simulated load failure"])
        }
        if !FileManager.default.fileExists(atPath: fileURL.path) {
            return []
        }
        let data = try Data(contentsOf: fileURL)
        return try JSONDecoder().decode([Client].self, from: data)
    }
    
    func save(_ clients: [Client]) throws {
        if simulateFailure {
            throw NSError(domain: "MockPersistence", code: -2, userInfo: [NSLocalizedDescriptionKey: "Simulated save failure"])
        }
        let data = try JSONEncoder().encode(clients)
        try data.write(to: fileURL, options: .atomic)
    }
}

class ClientViewmodelIntegrationTests: XCTestCase {
    var viewModel: ClientViewmodel!
    var tempDirectory: URL!
    
    override func setUpWithError() throws {
        // Given: Create a temporary directory for testing
        tempDirectory = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        try FileManager.default.createDirectory(at: tempDirectory, withIntermediateDirectories: true)
        
        // Given: Initialize viewModel with mock persistence
        let persistence = MockPersistenceService(temporaryDirectory: tempDirectory)
        viewModel = ClientViewmodel(persistence: persistence)
    }
    
    override func tearDownWithError() throws {
        // Given: Clean up temporary directory
        try FileManager.default.removeItem(at: tempDirectory)
        viewModel = nil
    }
    
    // Test Case 1 for loadClients: Loading from an empty file
    func testLoadClients_EmptyFile_ReturnsEmptyArray() throws {
        // Given: No data exists in the persistence layer
        // (Handled by setUpWithError creating a fresh temp directory)
        
        // When: Loading clients
        viewModel.loadClients()
        
        // Then: Clients array is empty and no error is set
        XCTAssertEqual(viewModel.clients.count, 0, "Clients array should be empty when no data exists")
        XCTAssertNil(viewModel.savingError, "No error should be set when loading an empty file")
    }
    
    // Test Case 2 for loadClients: Loading pre-existing clients
    func testLoadClients_PrePopulatedFile_LoadsCorrectly() throws {
        // Given: A file with one client exists
        let persistence = MockPersistenceService(temporaryDirectory: tempDirectory)
        let client = Client(nom: "Alice Smith", email: "alice.smith@example.com", dateCreationString: "2025-06-10T12:00:00.000Z")
        try persistence.save([client])
        
        // When: Loading clients
        viewModel.loadClients()
        
        // Then: Clients array contains the persisted client
        XCTAssertEqual(viewModel.clients.count, 1, "Clients array should contain one client")
        XCTAssertEqual(viewModel.clients.first?.nom, "Alice Smith", "Loaded client name should match")
        XCTAssertEqual(viewModel.clients.first?.email, "alice.smith@example.com", "Loaded client email should match")
        XCTAssertNil(viewModel.savingError, "No error should be set")
    }
    
    // Test Case 1 for createNewClient: Valid input
    func testCreateNewClient_ValidInput_SavesAndLoadsCorrectly() throws {
        // Given: Valid name and email
        let name = "Alice Smith"
        let email = "alice.smith@example.com"
        
        // When: Creating a new client
        viewModel.createNewClient(nom: name, email: email)
        
        // Then: Client is added in-memory and persisted
        XCTAssertEqual(viewModel.clients.count, 1, "Clients array should contain one client")
        XCTAssertEqual(viewModel.clients.first?.nom, name, "Client name should match")
        XCTAssertEqual(viewModel.clients.first?.email, email, "Client email should match")
        XCTAssertEqual(viewModel.succesMessage, "Client ajouté avec succes", "Success message should be set")
        XCTAssertNil(viewModel.savingError, "No error should be set")
        
        // Verify persistence by reloading
        let newViewModel = ClientViewmodel(persistence: MockPersistenceService(temporaryDirectory: tempDirectory))
        newViewModel.loadClients()
        XCTAssertEqual(newViewModel.clients.count, 1, "Persisted clients should contain one client")
        XCTAssertEqual(newViewModel.clients.first?.nom, name, "Persisted client name should match")
        XCTAssertEqual(newViewModel.clients.first?.email, email, "Persisted client email should match")
    }
    
    // Test Case 2 for createNewClient: Boundary case with long inputs
    func testCreateNewClient_LongInputs_SavesCorrectly() throws {
        // Given: Long but valid name and email
        let longName = String(repeating: "A", count: 100) // Boundary: 100 characters
        let longEmail = String(repeating: "a", count: 50) + "@example.com" // Boundary: 50-char local part
        
        // When: Creating a new client
        viewModel.createNewClient(nom: longName, email: longEmail)
        
        // Then: Client is added in-memory and persisted
        XCTAssertEqual(viewModel.clients.count, 1, "Clients array should contain one client")
        XCTAssertEqual(viewModel.clients.first?.nom, longName, "Client name should match")
        XCTAssertEqual(viewModel.clients.first?.email, longEmail, "Client email should match")
        XCTAssertEqual(viewModel.succesMessage, "Client ajouté avec succes", "Success message should be set")
        XCTAssertNil(viewModel.savingError, "No error should be set")
        
        // Verify persistence
        let newViewModel = ClientViewmodel(persistence: MockPersistenceService(temporaryDirectory: tempDirectory))
        newViewModel.loadClients()
        XCTAssertEqual(newViewModel.clients.count, 1, "Persisted clients should contain one client")
        XCTAssertEqual(newViewModel.clients.first?.nom, longName, "Persisted client name should match")
        XCTAssertEqual(newViewModel.clients.first?.email, longEmail, "Persisted client email should match")
    }
    
    // Test Case 3 for createNewClient: Empty name (failure case)
    func testCreateNewClient_EmptyName_DoesNotSave() throws {
        // Given: Empty name and valid email
        let name = ""
        let email = "alice.smith@example.com"
        
        // When: Attempting to create a client with an empty name
        viewModel.createNewClient(nom: name, email: email)
        
        // Then: No client is added, and error is set
        XCTAssertEqual(viewModel.clients.count, 0, "Clients array should remain empty")
        XCTAssertEqual(viewModel.savingError, "Veuillez renseigner un nom", "Error message should indicate empty name")
        XCTAssertNil(viewModel.succesMessage, "Success message should not be set")
        
        // Verify persistence
        let newViewModel = ClientViewmodel(persistence: MockPersistenceService(temporaryDirectory: tempDirectory))
        newViewModel.loadClients()
        XCTAssertEqual(newViewModel.clients.count, 0, "Persisted clients should remain empty")
    }
    
    // Test Case 4 for createNewClient: Invalid email (failure case)
    func testCreateNewClient_InvalidEmail_DoesNotSave() throws {
        // Given: Valid name but invalid email
        let name = "Alice Smith"
        let invalidEmail = "invalid-email"
        
        // When: Attempting to create a client with an invalid email
        viewModel.createNewClient(nom: name, email: invalidEmail)
        
        // Then: No client is added, and error is set
        XCTAssertEqual(viewModel.clients.count, 0, "Clients array should remain empty")
        XCTAssertEqual(viewModel.savingError, "L'email n'est pas valide", "Error message should indicate invalid email")
        XCTAssertNil(viewModel.succesMessage, "Success message should not be set")
        
        // Verify persistence
        let newViewModel = ClientViewmodel(persistence: MockPersistenceService(temporaryDirectory: tempDirectory))
        newViewModel.loadClients()
        XCTAssertEqual(newViewModel.clients.count, 0, "Persisted clients should remain empty")
    }
    
    // Test Case 5 for createNewClient: Duplicate email (failure case)
    func testCreateNewClient_DuplicateEmail_DoesNotSave() throws {
        // Given: A client already exists
        let name = "Alice Smith"
        let email = "alice.smith@example.com"
        viewModel.createNewClient(nom: name, email: email)
        
        // When: Attempting to create a client with the same email
        viewModel.createNewClient(nom: "Bob Johnson", email: email)
        
        // Then: No new client is added, and error is set
        XCTAssertEqual(viewModel.clients.count, 1, "Clients array should still contain only one client")
        XCTAssertEqual(viewModel.savingError, "Le client existe déjà.", "Error message should indicate duplicate client")
        
        // Verify persistence
        let newViewModel = ClientViewmodel(persistence: MockPersistenceService(temporaryDirectory: tempDirectory))
        newViewModel.loadClients()
        XCTAssertEqual(newViewModel.clients.count, 1, "Persisted clients should still contain only one client")
    }
    
    // Test Case 1 for deleteClient: Deleting an existing client
    func testDeleteClient_ExistingClient_RemovesAndSaves() throws {
        // Given: A client exists
        let name = "Alice Smith"
        let email = "alice.smith@example.com"
        viewModel.createNewClient(nom: name, email: email)
        let client = viewModel.clients.first!
        
        // When: Deleting the client
        viewModel.deleteClient(client: client)
        
        // Then: Client is removed in-memory and from persistence
        XCTAssertEqual(viewModel.clients.count, 0, "Clients array should be empty after deletion")
        XCTAssertEqual(viewModel.succesMessage, "Client supprimer avec success", "Success message should be set")
        XCTAssertNil(viewModel.savingError, "No error should be set")
        
        // Verify persistence
        let newViewModel = ClientViewmodel(persistence: MockPersistenceService(temporaryDirectory: tempDirectory))
        newViewModel.loadClients()
        XCTAssertEqual(newViewModel.clients.count, 0, "Persisted clients should be empty")
    }
    
    // Test Case 2 for deleteClient: Attempting to delete a non-existent client
    func testDeleteClient_NonExistentClient_NoChange() throws {
        // Given: A client that doesn't exist in the array
        let nonExistentClient = Client(nom: "Unknown", email: "unknown@example.com", dateCreationString: "2025-06-10T12:00:00.000Z")
        
        // When: Attempting to delete the non-existent client
        viewModel.deleteClient(client: nonExistentClient)
        
        // Then: No changes to clients array, no success message
        XCTAssertEqual(viewModel.clients.count, 0, "Clients array should remain empty")
        XCTAssertNil(viewModel.succesMessage, "Success message should not be set")
        XCTAssertNil(viewModel.savingError, "No error should be set")
        
        // Verify persistence
        let newViewModel = ClientViewmodel(persistence: MockPersistenceService(temporaryDirectory: tempDirectory))
        newViewModel.loadClients()
        XCTAssertEqual(newViewModel.clients.count, 0, "Persisted clients should remain empty")
    }
    
    // Test Case 1 for isNewClient: Client created today
    func testIsNewClient_CreatedToday_ReturnsTrue() throws {
        // Given: A client created today
        let name = "Alice Smith"
        let email = "alice.smith@example.com"
        viewModel.createNewClient(nom: name, email: email)
        let client = viewModel.clients.first!
        
        // When: Checking if the client is new
        let isNew = viewModel.isNewClient(client: client)
        
        // Then: Client is considered new
        XCTAssertTrue(isNew, "Client created today should be considered new")
    }
    
    // Test Case 2 for isNewClient: Client created on a different day
    func testIsNewClient_CreatedDifferentDay_ReturnsFalse() throws {
        // Given: A client with a creation date from a different day
        let persistence = MockPersistenceService(temporaryDirectory: tempDirectory)
        let client = Client(nom: "Alice Smith", email: "alice.smith@example.com", dateCreationString: "2025-06-09T12:00:00.000Z") // Yesterday
        try persistence.save([client])
        viewModel.loadClients()
        
        // When: Checking if the client is new
        let isNew = viewModel.isNewClient(client: viewModel.clients.first!)
        
        // Then: Client is not considered new
        XCTAssertFalse(isNew, "Client created on a different day should not be considered new")
    }
}
