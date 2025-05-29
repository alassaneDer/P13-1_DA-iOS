//
//  String+Validations.swift
//  Relayance
//
//  Created by Alassane Der on 29/05/2025.
//

import Foundation

extension String {
    func isEmail() -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        
        return emailTest.evaluate(with: self)
    }
}
