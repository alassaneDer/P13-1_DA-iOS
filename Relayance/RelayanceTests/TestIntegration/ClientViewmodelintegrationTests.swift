//
//  ClientViewmodelintegrationTests.swift
//  RelayanceTests
//
//  Created by Alassane Der on 30/05/2025.
//

import XCTest
@testable import Relayance

class ClientViewModelIntegrationTests: XCTestCase {
    
    var viewModel: ClientViewmodel!
    // URL pour un fichier de test temporaire
    var testFileURL: URL!
    
    // MARK: - Configuration et Nettoyage
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        // 1. Créer une URL de fichier de test unique pour chaque test
        testFileURL = FileManager.default.temporaryDirectory.appendingPathComponent("TestSource.json")
        
        // 2. Configurer PersistenceService pour utiliser cette URL de test
        PersistenceService.overrideFileURL = testFileURL
        
        if let bundleFileURL = Bundle(for: type(of: self)).url(forResource: "TestSource", withExtension: "json") {
            try FileManager.default.copyItem(at: bundleFileURL, to: testFileURL)
        }
        // 4. Initialiser le ViewModel. Il essaiera de charger depuis testFileURL.
        viewModel = ClientViewmodel()
    }
    
    override func tearDownWithError() throws {
        // Nettoyer après chaque test
        PersistenceService.clearTestData()
        PersistenceService.overrideFileURL = nil // Réinitialiser pour d'autres tests potentiels
        
        viewModel = nil
        try super.tearDownWithError()
    }
    
    func test_GivenValidJsonFile_WhenLoadingClients_ThenClientsAreLoadedCorrectly() throws {
        /// Given : json file created with 8 Clients
        
        /// When
        viewModel.chargerClients()
        
        /// Then
        let firstClient = viewModel.clients.first
        XCTAssertEqual(firstClient?.nom, "Frida Kahlo", "The first client name should be Frida Kahlo")
        XCTAssertEqual(firstClient?.email, "frida.kahlo@example.com", "The first client email should be frida.kahlo@example.com")
    }
    
    func test_GivenNeewClient_WheenCreatingClient_TheClientIsSavedAndPersisted() {
        /// Given: a viewmodel with clients
        XCTAssertEqual(viewModel.clients.count, 8, "Initially we should have 8 clients")
        
        /// When: create à neew client
        viewModel.creerNouveauClient(nom: "Alice Diouf", email: "alicediouf@mail.com")
        
        /// Then : client is added and persisted
        XCTAssertEqual(viewModel.clients.count, 9, "We should have 9 clients")
        let newClient = viewModel.clients.last
        XCTAssertEqual(newClient?.nom, "Alice Diouf", "The last created client name should be correct")
        XCTAssertEqual(newClient?.email,"alicediouf@mail.com", "The last created client name should be correct")
        
        let reloadedData = PersistenceService.load()
        XCTAssertEqual(reloadedData.count, 9, "Persisted datas should have 9 clients")
        XCTAssertEqual(reloadedData.last?.nom, "Alice Diouf", "The last persisted client name should be correct")
    }
    
    func test_GivenExistingClient_WhenCreatingDuplicate_ThenErrorMessageIsSet() {
        /// Given:
        XCTAssertTrue(viewModel.clients.contains(where: { $0.email == "frida.kahlo@example.com"}), "A Client with email frida.kahlo@example.com alreday exist")
        /// When:
        viewModel.creerNouveauClient(nom: "frida kahlo", email: "frida.kahlo@example.com")
        /// Then:
        XCTAssertEqual(viewModel.message, "Le client existe déjà.", "The error message is set")
        XCTAssertEqual(viewModel.clients.count, 8, "Clients should be 8")
    }
    
    func test_GivenInvalidEmail_WhenCreatingClient_ThenErrorMessageIsSet() {
        /// Given:
        let inValideEmail = "invalide-email"
        
        /// When:
        viewModel.creerNouveauClient(nom: "frida kahlo", email: inValideEmail)
        
        /// Then:
        XCTAssertEqual(viewModel.message, "L'email n'est pas valide", "The error message is set")
        XCTAssertEqual(viewModel.clients.count, 8, "Clients should be 8")
    }
    
    func test_GivenClient_WhenDeletingClient_ThenClientIsRemovedAndPersisted() {
        /// Given:
        XCTAssertEqual(viewModel.clients.count, 8, "Clients should be 8")
        let client = viewModel.clients.first!
        
        /// When:
        viewModel.supprimerClient(client: client)
        /// Then:
        XCTAssertEqual(viewModel.clients.count, 7, "Clients should be 7 after deletion")
        XCTAssertFalse(viewModel.clients.contains(where: { $0.email == "frida.kahlo@example.com"}), "Client deleted")
        
    }
    
    func test_GivenClient_WhenCheckingIfNew_ThenCorrectStatusIsReturned() {
        /// Given:
        let today = Date.now
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let nowString = dateFormatter.string(from: today)
        
        let newClient = Client(nom: "today client", email: "todayclient@mail.com", dateCreationString: nowString)
        /// When:
        let isNewClient = viewModel.estNouveauClient(client: newClient)
        
        /// Then:
        XCTAssertTrue(isNewClient, "Client created today should be new")
        
        
        /// Given
        let oldClient = Client(nom: "today client", email: "todayclient@mail.com", dateCreationString: "2025-06-01")
        /// When:
        let isOldClient = viewModel.estNouveauClient(client: oldClient)
        
        /// Then:
        XCTAssertFalse(isOldClient, "xxx")
    }
    
    func test_GivenClient_WhenFormattingDate_ThenCorrectStringIsReturned() {
        // Given: Un client avec une date de création
        let client = Client(nom: "Test Client", email: "test@example.com", dateCreationString: "2025-06-03")
        
        // When: Formater la date
        let formattedDate = viewModel.formatDateVersString(client: client)
        
        // Then: La date doit être formatée correctement
        XCTAssertEqual(formattedDate, "03-06-2025", "La date devrait être formatée en jj-mm-aaaa")
        
    }
}
