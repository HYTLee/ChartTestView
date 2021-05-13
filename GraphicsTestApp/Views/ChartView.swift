//
//  ChartView.swift
//  GraphicsTestApp
//
//  Created by AP Yauheni Hramiashkevich on 5/6/21.
//

import Foundation
import UIKit
import CoreGraphics

class ChartView: UIView {
    var graphData: ChartModel?
    var yValues: [String]?
    
    convenience init(graphData: ChartModel) {
           self.init(frame: CGRect.zero)
           self.graphData = graphData
             }
       
       // initWithFrame to init view from code
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
       }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        let chartPath = UIBezierPath()
        let heightOfChart = rect.height - 25
        let widthOfChart = rect.width
        let ySpacing = getYSpacing(heightOfChart: heightOfChart)
        let minimalY = getMinimalYValue()
        
        // Draw x lines of chart
        var widthOfLine: CGFloat = 0
        var numberOfLine = 0
        while widthOfLine <= heightOfChart {
            chartPath.move(to: CGPoint(x:0, y:widthOfLine))
            if numberOfLine != 0 {
                let yValue = setValueForYRow(currentPoint: chartPath.currentPoint, heightOfGraph: heightOfChart, rect: rect, ySpacing: ySpacing)
                addYLabel(point:  chartPath.currentPoint, value: yValue)
            }
            chartPath.addLine(to: CGPoint(x: rect.width, y: widthOfLine))
            widthOfLine = widthOfLine + heightOfChart / 5
            numberOfLine += 1
        }
        let yPointForXLabels = chartPath.currentPoint.y
        var xPointsForXLabels:[CGFloat] = []
        let numberOfXLabels = Int(widthOfChart / 120)
        var xPoint: CGFloat = 60
        for _ in 1...numberOfXLabels {
            xPointsForXLabels.append(xPoint)
            xPoint += 120
        }
        let xPointsStrings = setValuesForXRows(numberOfLabels: xPointsForXLabels.count)
        var numberOFXPoint = 0
        for point in xPointsForXLabels {
            let coordinatesForLabel = CGPoint(x: point, y: yPointForXLabels)
            addXLabel(point: coordinatesForLabel, value: xPointsStrings[numberOFXPoint])
            numberOFXPoint += 1
        }
        chartPath.close()
        UIColor.lightGray.set()
        chartPath.lineWidth = 0.5
        chartPath.stroke()
        
        //Draw chart lines
        guard let numberOfChartLines = graphData?.y?.count else { return }
        let numberOfYPoints = (graphData?.y?[0].count ?? 2) - 1
        let xSpaicing = rect.width / CGFloat(numberOfYPoints)
        
        for line in 0...(numberOfChartLines - 1) {
            let linePath = UIBezierPath()
            let yPoints = graphData?.y?[line]
            var xPointer: CGFloat = 0
            guard let initialY = yPoints?[0] else { return }
            let initialYCGPoint = heightOfChart - (CGFloat((initialY - minimalY)) * ySpacing)
            linePath.move(to: CGPoint(x: xPointer, y: initialYCGPoint))
            let numberOfYPoints = (yPoints?.count ?? 2) - 1
            for yPoint in 1...numberOfYPoints {
                xPointer += xSpaicing
                guard let currentY = yPoints?[yPoint] else { return }
                let yCGPoint = heightOfChart - (CGFloat((currentY - minimalY)) * ySpacing)
                linePath.addLine(to: CGPoint(x: xPointer, y: yCGPoint))
                let color = hexStringToUIColor(hex: graphData?.color?[line] ?? "#d3d3d3")
                color.set()
                linePath.lineWidth = 2
                linePath.stroke()
            }
            linePath.close()
         }
    }
    
    private func addYLabel(point: CGPoint, value: String) {
        let yLabel = UILabel(frame: CGRect(x: point.x + 5, y: point.y - 20, width: 100, height: 20))
        self.addSubview(yLabel)
        yLabel.textColor = .lightGray
        yLabel.text = value
    }
    
    private func addXLabel(point: CGPoint, value: String) {
        let xLabel = UILabel(frame: CGRect(x: point.x, y: point.y + 5, width: 100, height: 20))
        self.addSubview(xLabel)
        xLabel.textColor = .lightGray
        xLabel.text = value
    }
    
    private func setValueForYRow(currentPoint: CGPoint, heightOfGraph: CGFloat, rect: CGRect, ySpacing: CGFloat) -> String {
        var allYValues: [Int] = []
        
        let numberOfLines = (graphData?.y?.count ?? 1) - 1
        for y in 0...numberOfLines {
            let numberOfYPoints = (graphData?.y?[y].count ?? 1) - 1
            for yPoint in 0...numberOfYPoints {
                allYValues.append(graphData?.y?[y][yPoint] ?? 0)
            }
        }
        let minimalY = allYValues.min() ?? 0
        let maximalY = allYValues.max() ?? 1
        let rangeY = maximalY - minimalY
        print("heightOfGraph \(heightOfGraph)")
        print("currentY \(currentPoint.y)")
        print("range \(rangeY)")
        print("maximalY \(maximalY)")
        print("minimalY \(minimalY)")
        let yValue = ((heightOfGraph - currentPoint.y) / ySpacing) + CGFloat(minimalY)
        let yValueString = "\(Int(yValue))"
        return yValueString
    }
    
    private func setValuesForXRows(numberOfLabels: Int) -> [String] {
        var xValues: [String] = []
        
        let datePercentage = 100 / numberOfLabels
        for number in 1...numberOfLabels {
            guard let value = graphData?.x?[datePercentage * number] else { return ["Unknown"] }
            let date =  DateFormatter().convertDateMMdd(date: value)
            xValues.append(date)
        }
        return xValues
    }
    
    private func getYSpacing(heightOfChart: CGFloat) -> CGFloat {
        var allYValues: [Int] = []
        
        let numberOfLines = (graphData?.y?.count ?? 1) - 1
        for y in 0...numberOfLines {
            let numberOfYPoints = (graphData?.y?[y].count ?? 1) - 1
            for yPoint in 0...numberOfYPoints {
                allYValues.append(graphData?.y?[y][yPoint] ?? 0)
            }
        }
        let minimalY = allYValues.min() ?? 0
        let maximalY = allYValues.max() ?? 1
        let rangeOfYValues = maximalY - minimalY
        
        let ySpacing = heightOfChart / CGFloat(rangeOfYValues)
        return ySpacing
    }
    
    private func getMinimalYValue() -> Int {
        var allYValues: [Int] = []
        
        let numberOfLines = (graphData?.y?.count ?? 1) - 1
        for y in 0...numberOfLines {
            let numberOfYPoints = (graphData?.y?[y].count ?? 1) - 1
            for yPoint in 0...numberOfYPoints {
                allYValues.append(graphData?.y?[y][yPoint] ?? 0)
            }
        }
        let minimalY = allYValues.min() ?? 0
        return minimalY
    }
    
    func hexStringToUIColor(hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
