//
//  ChartModel.swift
//  GraphicsTestApp
//
//  Created by AP Yauheni Hramiashkevich on 5/8/21.
//

import Foundation

public struct GraphModel {
    public init(dataSets: [DataSet]) {
        self.dataSets = dataSets
    }

    public var dataSets: [DataSet]
}

