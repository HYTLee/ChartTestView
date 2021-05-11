//
//  JsonDecodeManager.swift
//  GraphicsTestApp
//
//  Created by AP Yauheni Hramiashkevich on 5/6/21.
//

import Foundation

class JsonDecodeManager {
    
    func decodeJson() -> Responses?  {
        if let url = Bundle.main.url(forResource: "chartData", withExtension: "json") {
               do {
                    let data = try Data(contentsOf: url)
                    let decoder = JSONDecoder()
                    let jsonData = try decoder.decode(Responses.self, from: data)
                
                    return jsonData
               } catch {
                    print("error:\(error)")
               }
           }
           return nil
    }
    
    func convertDataToChartModel(chartData: Response) -> ChartModel {
        var chart = ChartModel(x: [], y: [], name: [], color: [])
        let response = chartData
        for value in 1...response.columns[0].count - 1 {
            let date = Date(timeIntervalSince1970: TimeInterval(response.columns[0][value].getInt()))
            chart.x?.append(date)
        }
        let numberOfYs = response.columns.count - 1
        for y in 1...numberOfYs {
            var yArray: [Int] = []
            for yElement in 1...response.columns[y].count - 1 {
                yArray.append(response.columns[y][yElement].getInt())
            }
            chart.y?.append(yArray)
        }
        chart.name?.append(response.names.y0)
        chart.name?.append(response.names.y1)
        if response.names.y2 != nil {
            chart.name?.append(response.names.y2 ?? "nil")
        }
        if response.names.y3 != nil {
            chart.name?.append(response.names.y3 ?? "nil")
        }
        
        chart.color?.append(response.colors.y0)
        chart.color?.append(response.colors.y1)
        if response.colors.y2 != nil {
            chart.color?.append(response.colors.y2 ?? "nil")
        }
        if response.colors.y3 != nil {
            chart.color?.append(response.colors.y3 ?? "nil")
        }
        chart.x = chart.x?.sorted(by: { $0.compare($1) == .orderedAscending })
        return chart
    }
}
