//
//  ModelData.swift
//  Relayance
//
//  Created by Amandine Cousin on 10/07/2024.
//

import Foundation

struct ModelData {
    /// Loads and decodes JSON data from a file in the main bundle
    /// - returns: the decoded object of type T
    /// - throws: An error if the file connot be found or decoded
    static func chargement<T: Decodable>(_ filename: String, as type: T.Type = T.self) throws -> T {
        guard let fileURL = Bundle.main.url(forResource: filename, withExtension: "json") else {
            throw ModelDataError.fileNotFound(filename)
        }
        
        let data = try Data(contentsOf: fileURL)
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    }
}

enum ModelDataError: Error {
    case fileNotFound(String)
    case dataLoadingFailed(String, Error)
    case decodingFailed(String, Error)
}
