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
        /// When: Load clients from Source.json
        do {
            let clients: [Client] = try ModelData.chargement("Source")
            
            /// Then: Verify the loaded data
            XCTAssertFalse(clients.isEmpty, "Client list should not be empty")
            XCTAssertEqual(clients.first?.nom, "Frida Kahlo", "First client's name should be correct")
        } catch {
            XCTFail("Loading clients failed: \(error)")
        }
    }
}
