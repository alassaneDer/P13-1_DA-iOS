//
//  ClientViewmodelTests.swift
//  RelayanceTests
//
//  Created by Alassane Der on 29/05/2025.
//

import XCTest
@testable import Relayance

final class ClientViewmodelTests: XCTestCase {
    
    // MARK: creerNouveauClient()
    func test_creerNouveauClient_failWithIncorrectEmail() {
        /// Given : the email is incorrect
        let email = "incorrectEmail"
        let viewmodel = ClientViewmodel()
        /// When : the client is created with the incorrect email
        viewmodel.creerNouveauClient(nom: "John Doe", email: email)
        /// Then :
        XCTAssertEqual(viewmodel.message, "L'email n'est pas valide.")
    }
    
    func test_creerNouveauClient_storeClientCorrectly() {
        /// Given
        let viewmodel = ClientViewmodel()
        /// When
        viewmodel.creerNouveauClient(nom: "John Doe", email: "johndoe@mail.com")
        /// Then
        XCTAssertTrue(viewmodel.clients.contains { $0.email == "johndoe@mail.com"})
    }
    
    func test_creerNouveauClient_failIfClientAlreadyExist() {
        /// Given
        let viewmodel = ClientViewmodel()
        viewmodel.clients.append(Client(nom: "John Doe", email: "johndoe@mail.com", dateCreationString: "01-01-2025"))
        /// When
        viewmodel.creerNouveauClient(nom: "John Doe", email: "johndoe@mail.com")
        
        /// Then
        XCTAssertEqual(viewmodel.message, "Le client existe déjà.")
    }
    
    // MARK: - estNouveauClient()
    func test_estNouveauClient_ShouldReturnTrueForSameDay() {
        /// Given un client créé aujourd'hui
        let now = Date.now
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let nowString = dateFormatter.string(from: now)
        let client = Client(nom: "John Doe", email: "johndoe@mail.com", dateCreationString: nowString)
        
        let viewmodel = ClientViewmodel()
        /// When
        let isNew = viewmodel.estNouveauClient(client: client)
        
        /// Then
        XCTAssertTrue(isNew, "Le client doit être un nouveau client.")
    }
    
    func test_estNouveauClient_ShouldReturnFalseIfDateIsOld() {
        /// Given : le client à été créé à une date entérieure
        let oldDateString = "2022-05-24"
        let client = Client(nom: "John Doe", email: "johndoe@mail.com", dateCreationString: oldDateString)
        
        let viewmodel = ClientViewmodel()
        /// When
        let isNew = viewmodel.estNouveauClient(client: client)
        
        /// Then
        XCTAssertFalse(isNew, "Le client ne doit pas être considéré comme nouveau.")
    }
    
    
     // MARK: - test clientExiste()
     func test_ClientExist_returnTrueWhenClientInList() {
         /// Given
         let todayString = "2022-05-24"
         let newClient = Client(nom: "John Doe", email: "johndoe@mail.com", dateCreationString: todayString)
         let viewmodel = ClientViewmodel()
         viewmodel.clients.append(newClient)
         /// When
         let isExistedClient = viewmodel.clientExist(client: newClient)
 
         /// Then
         XCTAssertTrue(isExistedClient, "Le client existe")
     }
 
     func test_ClientExist_returnFalseIfTheClientDoesNotExist() {
         let todayString = "2022-05-24"
         let newClient = Client(nom: "Jack Doe", email: "jackdoe@mail.com", dateCreationString: todayString)
         
         let viewmodel = ClientViewmodel()
         /// When
         let isExistedClient = viewmodel.clientExist(client: newClient)
         /// Then
         XCTAssertEqual(isExistedClient, false, "Le client n'existe pas")
     }
 
     // MARK: - tests formatDateVersString
     func test_formatDateVersString_returnFormattedDate() {
         /// Given
         let date = "2024-01-01T12:00:00.000Z"
         let expectedDate = "01-01-2024"
         /// When
         let client = Client(nom: "test", email: "test@mail.com", dateCreationString: date)
         let viewmodel = ClientViewmodel()
         let formattedDate = viewmodel.formatDateVersString(client: client)
         /// Then
         XCTAssertEqual(formattedDate, expectedDate, "la date doit être formattée correctement.")
     }
 
     func test_formatDateVersString_returnStringDateIfGiveItStringDate() {
         /// Given
         /// When
         /// Then
     }

    // MARK: - tests supprimerClient
    func test_supprimerClient_deleteClientCorrectly() {
        /// Given
        let viewmodel = ClientViewmodel()
        let client = Client(nom: "test", email: "testdeletion@mail.com", dateCreationString: "01-01-2025")
        viewmodel.clients.append(client)
        /// When
        viewmodel.supprimerClient(client: client)
        /// Then
        XCTAssertFalse(viewmodel.clients.contains { $0.email == "testdeletion@mail.com"})
    }
}
