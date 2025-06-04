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
        /// Given: A client with a valid date string
        let client = Client(nom: "John Doe", email: "johndoe@mail.com", dateCreationString: "2024-12-31")
        let expectedDate = Date.dateFromString("2024-12-31")
        
        /// Then: Verify client properties
        XCTAssertEqual(client.nom, "John Doe", "Client name should be correct")
        XCTAssertEqual(client.email, "johndoe@mail.com", "Client email should be correct")
        XCTAssertEqual(client.dateCreation, expectedDate, "Creation date shoould match the provided date")
    }
    
    func test_clientInitialization_returnNowWhenDateIsIncorrect() {
        /// Given:  crée une date incorrect
        let incorrectDate = "incorrect-date"
        
        /// When: initialise client with the incorrect date
        let client = Client(nom: "John", email: "johndoe@mail.com", dateCreationString: incorrectDate)
        
        /// Then: verification de la date si c'est aujourd'hui
        XCTAssertEqual(client.nom, "John", "Client name should be correct")
        XCTAssertEqual(client.email, "johndoe@mail.com", "Client email should be correct")
        XCTAssertLessThanOrEqual(client.dateCreation, Date.now, "Creation date should be now or earlier")
    }
}
