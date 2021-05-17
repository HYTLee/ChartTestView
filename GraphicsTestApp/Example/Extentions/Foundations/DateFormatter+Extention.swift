//
//  DateFormatter+Extention.swift
//  GraphicsTestApp
//
//  Created by AP Yauheni Hramiashkevich on 5/9/21.
//

import Foundation

extension DateFormatter {
    
    func convertDate(date: Date, dateFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat 
        return dateFormatter.string(from: date as Date)
    }

}

