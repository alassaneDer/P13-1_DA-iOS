//
//  ModelDataTest.swift
//  RelayanceTests
//
//  Created by Alassane Der on 30/05/2025.
//

import XCTest
@testable import Relayance

final class ModelDataTests: XCTestCase {
    func test_Chargement_ShouldLoadValidDatas() {
        /// When
        let clients: [Client] = ModelData.chargement("Source.json")
        
        /// Then
        XCTAssertFalse(clients.isEmpty, "La liste de client ne doit pas être vide.")
        XCTAssertEqual(clients.first?.nom, "Frida Kahlo", "Le nom du premier client doit être correct.")
    }
}

