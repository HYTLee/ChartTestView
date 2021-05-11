//
//  Response.swift
//  GraphicsTestApp
//
//  Created by AP Yauheni Hramiashkevich on 5/4/21.
//

import Foundation

struct Response: Codable {
    let columns: [[Column]]
    let types, names, colors: Settings
}

typealias Responses = [Response]
