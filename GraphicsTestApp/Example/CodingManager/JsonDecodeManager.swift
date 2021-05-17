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
    
    func convertDataToChartModel(chartData: Response) -> GraphModel {
        var dataSets: [DataSet] = []
        let response = chartData
        let numberOfArraysWithDataSets = response.columns.count - 1
        for numberOfDataSet in 1...numberOfArraysWithDataSets {
            var dataSet = DataSet(x: [], y: [], name: "", color: "")
            dataSet.x = setXValuesToChartData(response: chartData)
            dataSet.y = setYValuesToChartData(response: chartData, numberOfY: numberOfDataSet)
            switch numberOfDataSet {
            case 1:
                dataSet.color = response.colors.y0
                dataSet.name = response.names.y0
            case 2:
                dataSet.color = response.colors.y1
                dataSet.name = response.names.y1

            case 3:
                dataSet.color = response.colors.y2 ?? "#3DC23F"
                dataSet.name = response.names.y2 ?? "Default"
            case 4:
                dataSet.color = response.colors.y3 ?? "#3DC23F"
                dataSet.name = response.names.y3 ?? "Default"
            default:
                dataSet.color = response.colors.y0
                dataSet.name = response.names.y0
            }
            dataSets.append(dataSet)
        }
        let chart = GraphModel(dataSets: dataSets)
        return chart
    }
    
    private func setXValuesToChartData(response: Response) -> [Date]{
        let numberOfXs = response.columns[0].count - 1
        var xArray: [Date] = []
        for x in 1...numberOfXs {
            let date = Date(timeIntervalSince1970: TimeInterval(response.columns[0][x].getInt()))
            xArray.append(date)
        }
        return xArray
    }
    
    private func setYValuesToChartData(response: Response, numberOfY: Int) -> [Int]{
        let numberOfYs = response.columns[numberOfY].count - 1
        var yArray: [Int] = []
        for y in 1...numberOfYs {
            let yData = response.columns[numberOfY][y].getInt()
            yArray.append(yData)
        }
        return yArray
    }
}
