//
//  ClientViewmodelTests.swift
//  RelayanceTests
//
//  Created by Alassane Der on 29/05/2025.
//

import XCTest
@testable import Relayance

final class ClientViewmodelTests: XCTestCase {
    
    // MARK: load()
    // MARK: save()
    // MARK: creerNouveauClient()
    func test_createNewClient_failWithIncorrectEmail() {
        /// Given : the email is incorrect
        let mock = MockPersistence()
        let viewmodel = ClientViewmodel(persistence: mock)
        let email = "incorrectEmail"

        /// When : the client is created with the incorrect email
        viewmodel.createNewClient(nom: "John Doe", email: email)
        
        /// Then :
        XCTAssertEqual(viewmodel.clients.count, 0)
        XCTAssertEqual(viewmodel.savingError, "L'email n'est pas valide", "Error message should be set")
        XCTAssertFalse(mock.savedCalled, "nothing should be saved")
    }
    
    func test_createNewClient_failWithEmptyName() {
        /// Given : the email is incorrect
        let mock = MockPersistence()
        let viewmodel = ClientViewmodel(persistence: mock)
        
        let name = ""
        /// When : the client is created with the incorrect email
        viewmodel.createNewClient(nom: name, email: "correct@mail.com")
        
        /// Then :
        XCTAssertEqual(viewmodel.clients.count, 0)
        XCTAssertEqual(viewmodel.savingError, "Veuillez renseigner un nom", "Error message should be set")
        XCTAssertFalse(mock.savedCalled, "nothing should be saved")
    }
    
    func test_createNewClient_storeClientCorrectly() {
        /// Given
        let mock = MockPersistence()
        let viewmodel = ClientViewmodel(persistence: mock)
        
        /// When
        viewmodel.createNewClient(nom: "John Cena", email: "johncena@mail.com")
        
        // Then: Verify the client is added
        XCTAssertEqual(viewmodel.clients.count, 1)
        XCTAssertTrue(viewmodel.clients.contains { $0.email == "johncena@mail.com" }, "Client should be added")
        XCTAssertEqual(viewmodel.succesMessage, "Client ajouté avec succes", "Success message should be set")
        XCTAssertTrue(mock.savedCalled, "created client should be should be saved")
    }
    
    func test_createNewClient_failIfClientAlreadyExist() {
        /// Given
        let mock = MockPersistence()
        let viewmodel = ClientViewmodel(persistence: mock)
        viewmodel.clients.append(Client(nom: "John Doe", email: "johndoe@mail.com", dateCreationString: "01-01-2025"))
        /// When
        viewmodel.createNewClient(nom: "John Doe", email: "johndoe@mail.com")
        
        /// Then
        XCTAssertEqual(viewmodel.clients.count, 1)
        XCTAssertEqual(viewmodel.savingError, "Le client existe déjà.")
        XCTAssertFalse(mock.savedCalled, "nothing should be saved")
    }
    
    // MARK: - estNouveauClient()
    func test_isNewClient_ShouldReturnTrueForSameDay() {
        /// Given
        let now = Date.now
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let nowString = dateFormatter.string(from: now)
        let client = Client(nom: "John Doe", email: "johndoe@mail.com", dateCreationString: nowString)
        
        let mock = MockPersistence()
        let viewmodel = ClientViewmodel(persistence: mock)
        /// When
        let isNew = viewmodel.isNewClient(client: client)
        
        /// Then
        XCTAssertTrue(isNew, "Client should be considered new")
    }
    
    func test_isNewClient_ShouldReturnFalseIfDateIsOld() {
        /// Given : le client à été créé à une date entérieure
        let oldDateString = "2022-05-24"
        let client = Client(nom: "John Doe", email: "johndoe@mail.com", dateCreationString: oldDateString)
        
        let mock = MockPersistence()
        let viewmodel = ClientViewmodel(persistence: mock)
        /// When
        let isNew = viewmodel.isNewClient(client: client)
        
        /// Then
        XCTAssertFalse(isNew, "Client should not be considered new")
    }
    
    
    // MARK: - test clientExiste()
    func test_ClientExist_returnTrueWhenClientInList() {
        /// Given
        let todayString = "2022-05-24"
        let newClient = Client(nom: "John Doe", email: "johndoe@mail.com", dateCreationString: todayString)
        let mock = MockPersistence()
        let viewmodel = ClientViewmodel(persistence: mock)
        viewmodel.clients.append(newClient)
        /// When
        let isExistedClient = viewmodel.clientExist(client: newClient)
        
        /// Then
        XCTAssertTrue(isExistedClient, "Client should exist")
    }
    
    func test_ClientExist_returnFalseIfTheClientDoesNotExist() {
        let todayString = "2022-05-24"
        let newClient = Client(nom: "Jack Doe", email: "jackdoe@mail.com", dateCreationString: todayString)
        
        let mock = MockPersistence()
        let viewmodel = ClientViewmodel(persistence: mock)
        /// When
        let isExistedClient = viewmodel.clientExist(client: newClient)
        /// Then
        XCTAssertEqual(isExistedClient, false, "Client should not existe")
    }
    
    // MARK: - tests formatDateVersString
    func test_formatDateToString_returnFormattedDate() {
        /// Given
        let date = "2024-01-01T12:00:00.000Z"
        let expectedDate = "01-01-2024"
        
        /// When
        let client = Client(nom: "test", email: "test@mail.com", dateCreationString: date)
        let mock = MockPersistence()
        let viewmodel = ClientViewmodel(persistence: mock)
        let formattedDate = viewmodel.formatDateToString(client: client)
        
        /// Then
        XCTAssertEqual(formattedDate, expectedDate, "Date should be formatted correctly")
    }
    
    // MARK: - tests supprimerClient
    func test_deleteClient_deleteClientCorrectly() {
        /// Given
        let mock = MockPersistence()
        let viewmodel = ClientViewmodel(persistence: mock)
        let client = Client(nom: "test", email: "testdeletion@mail.com", dateCreationString: "01-01-2025")
        viewmodel.clients.append(client)
        
        /// When
        viewmodel.deleteClient(client: client)
        
        /// Then: Verify the client is removed
        XCTAssertEqual(viewmodel.clients.count, 0)
        XCTAssertTrue(mock.savedCalled, "nothing should be saved")
        XCTAssertFalse(viewmodel.clients.contains { $0.email == "testdeletion@mail.com" }, "Client should be deleted")
        XCTAssertEqual(viewmodel.succesMessage, "Client supprimer avec success", "Success message should be set")
    }
}
