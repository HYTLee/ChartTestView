//
//  DateFormatter+Extention.swift
//  GraphicsTestApp
//
//  Created by AP Yauheni Hramiashkevich on 5/9/21.
//

import Foundation

extension DateFormatter {
    
    func convertDateToHHmm(date: Date, twelvehoursFromat: Bool) -> String {
        let dateFormatter = DateFormatter()
        if twelvehoursFromat {
            dateFormatter.dateFormat = "HH:mm a"
            return dateFormatter.string(from: date as Date)
        } else {
            dateFormatter.dateFormat = "HH:mm"
            return dateFormatter.string(from: date as Date)
        }
    }
    
    func convertDateToEMDY(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE,dd MMMM yyyy"
        return dateFormatter.string(from: date as Date)
    }

    func convertDateToED(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE,dd"
        return dateFormatter.string(from: date as Date)
    }

    func convertDateMMdd(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd"
        return dateFormatter.string(from: date as Date)
    }

}

