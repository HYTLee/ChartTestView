//
//  Column.swift
//  GraphicsTestApp
//
//  Created by AP Yauheni Hramiashkevich on 5/6/21.
//

import Foundation

enum Column: Codable {
    case integer(Int)
    case string(String)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Int.self) {
            self = .integer(x)
            return
        }
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        throw DecodingError.typeMismatch(Column.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for Column"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .integer(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        }
    }
    
    func getInt() -> Int {
         switch self {
         case .integer(let int):
             return int
         case .string(_):
             return 0
         }
     }
}
