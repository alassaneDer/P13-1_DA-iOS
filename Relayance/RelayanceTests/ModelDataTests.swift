//
//  ModelDataTests.swift
//  RelayanceTests
//
//  Created by Alassane Der on 29/05/2025.
//

import XCTest
@testable import Relayance

final class ModelDataTests: XCTestCase {
    func test_Chargement_ShouldLoadValidDatas() {
        /// When
        let clients: [Client] = ModelData.chargement("SourceMock.json")
        
        /// Then
        XCTAssertFalse(clients.isEmpty, "La liste de client ne doit pas être vide.")
        XCTAssertEqual(clients.first?.nom, "John Doe", "Le nom du premier client doit être John Doe.")
    }
}

