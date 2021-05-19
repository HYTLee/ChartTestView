//
//  ChartModel.swift
//  GraphicsTestApp
//
//  Created by AP Yauheni Hramiashkevich on 5/8/21.
//

import Foundation

//public struct GraphModel {
//    var x: [Date]?
//    var y: [[Int]]?
//    var name: [String]?
//    var color: [String]?
//}

public struct GraphModel {
    var dataSets: [DataSet]
}

public struct DataSet {
    var x: [Date]
    var y: [Int]
    var name: String
    var color: String
}
