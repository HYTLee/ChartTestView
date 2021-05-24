//
//  DateFormatter+Extention.swift
//  GraphicsTestApp
//
//  Created by AP Yauheni Hramiashkevich on 5/9/21.
//

import Foundation

extension Date {
    func formated(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
