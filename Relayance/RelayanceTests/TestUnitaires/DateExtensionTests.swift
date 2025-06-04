//
//  DateExtensionTests.swift
//  RelayanceTests
//
//  Created by Alassane Der on 29/05/2025.
//

import XCTest
@testable import Relayance

final class DateExtensionTests: XCTestCase {
    func test_DateFromString_ShouldParseValidISODate() {
        /// Given : une date specifique
        let isoDateString = "2023-12-31"
        
        /// When : conversion en date
        let date = Date.dateFromString(isoDateString)
        
        /// Then : verification que la date est bien parsée
        XCTAssertNotNil(date, "Date should be parsed successfully")
        let components = Calendar.current.dateComponents([.year, .month, .day], from: date!)
        XCTAssertEqual(components.year, 2023, "Year should be 2023")
        XCTAssertEqual(components.month, 12, "Month should be 12")
        XCTAssertEqual(components.day, 31, "Day should be 31")
    }
    
    func test_StringFormatDate_ShouldFormatDateCorrectly() {
        /// Given : une date specifique
        let date = Calendar.current.date(from: DateComponents(year: 2023, month: 12, day: 1))!
        
        /// When : conversion de la date en string avec StringFormatDate()
        let dateString = Date.stringFromDate(date)
        
        /// Then : La chaine doit être formatté en dd-MM-yyyy.
        XCTAssertEqual(dateString, "01-12-2023", "Date should be formatted as dd-MM-yyyy.")
    }
    
    func test_DateComponents_shoulfReturnCorrectValues() {
        /// Given : une date spécifique
        let date = Calendar.current.date(from: DateComponents(year: 2024, month: 12, day: 31))!
        
        /// When : extraire les composants
        let day = date.getDay()
        let month = date.getMonth()
        let year = date.getYear()
        
        /// Then : les composants doivent correspondre
        XCTAssertEqual(day, 31, "Day should be 31")
        XCTAssertEqual(month, 12, "Month should be 12")
        XCTAssertEqual(year, 2024, "Yeat should be 2024")
    }
}
