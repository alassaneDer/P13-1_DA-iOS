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
    
    func test_clientInitialization_returnTheCorrectDate() {
        let client = Client(nom: "John Doe", email: "johndoe@mail.com", dateCreationString: "2024-12-31")
        let expectedDate = Date.dateFromString("2024-12-31")
        
        XCTAssertEqual(client.nom, "John Doe", "Le nom du client devrait être correct")
        XCTAssertEqual(client.email, "johndoe@mail.com", "L'email du client devrait être correct")
        XCTAssertEqual(client.dateCreation, expectedDate, "La date de création devrait correspondree à la date fournie")
    }
    
    func test_clientInitialization_returnNowWhenDateIsIncorrect() {
        /// Given:  crée une date incorrect
        let incorrectDate = "incorrect-date"
        
        /// When: initialise client with the incorrect date
        let client = Client(nom: "John", email: "johndoe@mail.com", dateCreationString: incorrectDate)
        
        /// Then: verification de la date si c'est aujourd'hui
        XCTAssertEqual(client.nom, "John", "Le nom du client devrait être correct")
        XCTAssertEqual(client.email, "johndoe@mail.com", "L'email du client devrait être correct")
        XCTAssertLessThanOrEqual(client.dateCreation, Date.now, "Le clieent doit être créé aujourd'hui.")
    }
}
