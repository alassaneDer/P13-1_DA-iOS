//
//  ClientTests.swift
//  RelayanceTests
//
//  Created by Alassane Der on 29/05/2025.
//

import XCTest
@testable import Relayance

final class ClientTests: XCTestCase {
    
    // MARK: test de l'initialisation
    func test_ClientInitialization_StoresCorrectNameAndEmail() {
        let client = Client(nom: "John Doe", email: "johndoe@mail.com", dateCreationString: "2024-12-31")
        
        XCTAssertEqual(client.nom, "John Doe", "Le nom du client devrait être correct")
        XCTAssertEqual(client.email, "johndoe@mail.com", "L'email du client devrait être correct")
    }
    
    func test_ClientInitialization_ReturnTheCorrectDate() {
        let client = Client(nom: "John Doe", email: "johndoe@mail.com", dateCreationString: "2024-12-31")
        let expectedDate = Date.dateFromString("2024-12-31")
        
        XCTAssertEqual(client.dateCreation, expectedDate, "La date de création devrait correspondree à la date fournie")
    }
    
    func test_ClientInitialization_ReturnNowWhenDateIsIncorrect() {
        /// Given:  crée une date incorrect
        let incorrectDate = "incorrect-date"
        
        /// When: initialise client with the incorrect date
        let client = Client(nom: "John", email: "Doe", dateCreationString: incorrectDate)
        
        /// Then: verification de la date si c'est aujourd'hui
        XCTAssertLessThanOrEqual(client.dateCreation, Date.now, "Le clieent doit être créé aujourd'hui.")
    }
}
//    // MARK: test de creerNouveauClient()
//        /// la methode que je teste ici crée un client avec nom et un email et
//        /// avec un date de creation correspond à aujourdhui avec un format ISO
//    func test_CreerNouveauClient_ShouldCreateClientWithCorrectNameAndEmail() {
//        /// Given : nom et email
//        let name = "John Doe"
//        let email = "johndoe@gmail.com"
//        
//        /// When : appelle de la méthode creerNouveeauClieent
//        let client = Client.creerNouveauClient(nom: name, email: email)
//        
//        /// Then : les propriétés du client doivent correspondre
//        XCTAssertEqual(client.nom, name, "le nom doit être \(name)")
//        XCTAssertEqual(client.email, email, "le nom doit être \(email)")
//    }
//    
//    func test_CreerNouveauClient_ShouldCreateClientWithCurrentDate() {
//        /// Given : crée la date d'aujourd'hui normalisée
//        let now = Date.now
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
//        let nowString = dateFormatter.string(from: now)
//        
//        let nowNormalized = Date.dateFromString(nowString)
//        
//        /// When : crée un client avec la date d'aujourd'hui
//        let client = Client.creerNouveauClient(nom: "test", email: "test@mail.com")
//        
//        /// Then
//        XCTAssertEqual(client.dateCreation, nowNormalized, "La date de création devrait correspondree à la date d'aujourd'hui")
//    }
//    
//    // MARK: test estNouveauClient()
//    func test_estNouveauClient_ShouldReturnTrueForSameDay() {
//        /// Given un client créé aujourd'hui
//        let now = Date.now
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
//        let nowString = dateFormatter.string(from: now)
//        let client = Client(nom: "John Doe", email: "johndoe@mail.com", dateCreationString: nowString)
//        
//        /// When
//        let isNew = client.estNouveauClient()
//        
//        /// Then
//        XCTAssertTrue(isNew, "Le client doit être un nouveau client.")
//    }
//    
//    func test_estNouveauClient_ShouldReturnFalseIfDateIsOld() {
//        /// Given : le client à été créé à une date entérieure
//        let oldDateString = "2022-05-24"
//        let client = Client(nom: "John Doe", email: "johndoe@mail.com", dateCreationString: oldDateString)
//        
//        /// When
//        let isNew = client.estNouveauClient()
//        
//        /// Then
//        XCTAssertFalse(isNew, "Le client ne doit être considéré comme nouveau.")
//    }
//    
//    // MARK: test clientExiste()
//    func test_ClientExist_returnTrueWhenClientInList() {
//        /// Given
//        let todayString = "2022-05-24"
//        let client1 = Client(nom: "John Doe", email: "johndoe@mail.com", dateCreationString: todayString)
//        let client2 = Client(nom: "John Cena", email: "johncena@mail.com", dateCreationString: todayString)
//        let client3 = Client(nom: "Johnson", email: "johnson@mail.com", dateCreationString: todayString)
//        let clientList: [Client] = [client1, client2, client3]
//        
//        /// When
//        let isExistedClient = client1.clientExiste(clientsList: clientList)
//        
//        /// Then
//        XCTAssertTrue(isExistedClient, "Le client existe")
//    }
//    
//    func test_ClientExist_returnFalseIfTheClientDoesNotExist() {
//        /// Given
//        let todayString = "2022-05-24"
//        let client1 = Client(nom: "John Doe", email: "johndoe@mail.com", dateCreationString: todayString)
//        let client2 = Client(nom: "John Cena", email: "johncena@mail.com", dateCreationString: todayString)
//        let clientList: [Client] = [client1]
//        
//        /// When
//        let isExistedClient = client2.clientExiste(clientsList: clientList)
//        
//        /// Then
//        XCTAssertFalse(isExistedClient, "Le client n'existe pas")
//    }
//    
//    // MARK: tests formatDateVersString
//    func test_formatDateVersString_returnFormattedDate() {
//        /// Given
//        let date = "2024-01-01T12:00:00.000Z"
//        let expectedDate = "01-01-2024"
//        /// When
//        let client = Client(nom: "test", email: "test@mail.com", dateCreationString: date)
//        let formattedDate = client.formatDateVersString()
//        /// Then
//        XCTAssertEqual(formattedDate, expectedDate, "la date doit être formattée correctement.")
//    }
//    
//    func test_formatDateVersString_returnStringDateIfGiveItStringDate() {
//        /// Given
//        /// When
//        /// Then
//    }
