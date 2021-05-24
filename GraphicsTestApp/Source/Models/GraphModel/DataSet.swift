//
//  DataSet.swift
//  GraphicsTestApp
//
//  Created by AP Yauheni Hramiashkevich on 5/24/21.
//

import Foundation

public struct DataSet {
    public init(x: [Date], y: [Int], name: String, color: String) {
        self.x = x
        self.y = y
        self.name = name
        self.color = color
    }
    
    var x: [Date]
    var y: [Int]
    var name: String
    var color: String
}
