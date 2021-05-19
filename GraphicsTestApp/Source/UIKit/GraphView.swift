//
//  ChartView.swift
//  GraphicsTestApp
//
//  Created by AP Yauheni Hramiashkevich on 5/6/21.
//

import Foundation
import UIKit
import CoreGraphics

public class GraphView: UIView {
    var initialGraphData: GraphModel? {
        didSet {
            self.updateUI()
        }
    }
    var drawingGraphData: GraphModel?
    var graphLinesColor = UIColor.lightGray
    var textColor = UIColor.lightGray
    var linesWidth: CGFloat = 2
    var staticLinesWidth: CGFloat = 1
    var isGraphLabelsVisible: Bool = true
    
    public convenience init(graphData: GraphModel) {
        self.init(frame: CGRect.zero)
        self.initialGraphData = graphData
        self.drawingGraphData = initialGraphData
    }

    public override func draw(_ rect: CGRect) {
        let chartPath = UIBezierPath()
        let heightOfGraph = rect.height - 75
        let widthOfChart = rect.width
        let ySpacing = getYSpacing(heightOfChart: heightOfGraph)
        let minimalY = getMinimalYValue()
        var rangeBetweenXPoint: CGFloat = 60
        let numberOfXLabels = Int(widthOfChart / 120)
        self.addYLinesButtons(graphHeight: heightOfGraph)
        
        // Draw x lines of graph
        self.drawStaticLines(chartPath: chartPath, rect: rect, heightOfChart: heightOfGraph, ySpacing: ySpacing)
        if isGraphLabelsVisible {
            self.setXLabelsWithData(chartPath: chartPath, numberOfXLabels: numberOfXLabels, rangeBetweenXPoint: &rangeBetweenXPoint)
        }
        chartPath.close()
        self.graphLinesColor.set()
        chartPath.lineWidth = staticLinesWidth
        chartPath.stroke()
        self.drawGraphicLines(rect: rect, heightOfChart: heightOfGraph, minimalY: minimalY, ySpacing: ySpacing)
    }
}

//MARK: Private methods
private extension GraphView {
    func addYLabel(point: CGPoint, value: String) {
        let yLabel = UILabel(frame: CGRect(x: point.x + 5,
                                           y: point.y - 20,
                                           width: 100,
                                           height: 20))
        self.addSubview(yLabel)
        yLabel.textColor = textColor
        yLabel.text = value
    }
    
    func addXLabel(point: CGPoint, value: String) {
        let xLabel = UILabel(frame: CGRect(x: point.x,
                                           y: point.y + 5,
                                           width: 100,
                                           height: 20))
        self.addSubview(xLabel)
        xLabel.textColor = textColor
        xLabel.text = value
    }
    
    func setValueForYRow(currentPoint: CGPoint,
                                 heightOfGraph: CGFloat,
                                 rect: CGRect,
                                 ySpacing: CGFloat) -> String {
        var allYValues: [Int] = []
        let numberOfLines = (drawingGraphData?.dataSets.count ?? 1) - 1
        for y in 0...numberOfLines {
            let numberOfYPoints = (drawingGraphData?.dataSets[y].y.count ?? 1) - 1
            for yPoint in 0...numberOfYPoints {
                allYValues.append(drawingGraphData?.dataSets[y].y[yPoint] ?? 0)
            }
        }
        let minimalY = allYValues.min() ?? 0
        let yValue = ((heightOfGraph - currentPoint.y) / ySpacing) + CGFloat(minimalY)
        let yValueString = "\(Int(yValue))"
        return yValueString
    }
    
    func setValuesForXRows(numberOfLabels: Int) -> [String] {
        var xValues: [String] = []
        
        let datePercentage = 100 / numberOfLabels
        for number in 1...numberOfLabels {
            guard let value = drawingGraphData?.dataSets[0].x[datePercentage * number] else { return ["Unknown"] }
            let date = DateFormatter().convertDate(date: value, dateFormat: "MMM dd")
            xValues.append(date)
        }
        return xValues
    }
    
    func getYSpacing(heightOfChart: CGFloat) -> CGFloat {
        var allYValues: [Int] = []
        
        let numberOfLines = (drawingGraphData?.dataSets.count ?? 1) - 1
        for y in 0...numberOfLines {
            let numberOfYPoints = (drawingGraphData?.dataSets[y].y.count ?? 1) - 1
            for yPoint in 0...numberOfYPoints {
                allYValues.append(drawingGraphData?.dataSets[y].y[yPoint] ?? 0)
            }
        }
        let minimalY = allYValues.min() ?? 0
        let maximalY = allYValues.max() ?? 1
        let rangeOfYValues = maximalY - minimalY
        let ySpacing = heightOfChart / CGFloat(rangeOfYValues)
        return ySpacing
    }
    
    func getMinimalYValue() -> Int {
        var allYValues: [Int] = []
        
        let numberOfLines = (drawingGraphData?.dataSets.count ?? 1) - 1
        for y in 0...numberOfLines {
            let numberOfYPoints = (drawingGraphData?.dataSets[y].y.count ?? 1) - 1
            for yPoint in 0...numberOfYPoints {
                allYValues.append(drawingGraphData?.dataSets[y].y[yPoint] ?? 0)
            }
        }
        let minimalY = allYValues.min() ?? 0
        return minimalY
    }
    
    func removeAllSubview()  {
        for view in self.subviews{
            view.removeFromSuperview()
        }
    }
    
    func updateUI()  {
        self.removeAllSubview()
        self.setNeedsDisplay()
    }
    
    func setXSpacing(rect: CGRect) -> CGFloat {
        let numberOfYPoints = (drawingGraphData?.dataSets[0].y.count ?? 2) - 1
        let xSpacing = rect.width / CGFloat(numberOfYPoints)
        return xSpacing
    }
    
    func setPointForXLabels(numberOfXLabels: Int, rangeBetweenXPoints: inout CGFloat) -> [CGFloat] {
        var xPointsForXLabels: [CGFloat] = []
        for _ in 1...numberOfXLabels {
            xPointsForXLabels.append(rangeBetweenXPoints)
            rangeBetweenXPoints += 120
        }
        return xPointsForXLabels
    }
    
    func setXLabelsWithData(chartPath: UIBezierPath, numberOfXLabels: Int, rangeBetweenXPoint: inout CGFloat)  {
        let yPointForXLabels = chartPath.currentPoint.y
        let xPointsForXLabels:[CGFloat] = setPointForXLabels(numberOfXLabels: numberOfXLabels, rangeBetweenXPoints: &rangeBetweenXPoint)
        let xPointsStrings = setValuesForXRows(numberOfLabels: xPointsForXLabels.count)
        var numberOFXPoint = 0
        for point in xPointsForXLabels {
            let coordinatesForLabel = CGPoint(x: point, y: yPointForXLabels)
            self.addXLabel(point: coordinatesForLabel, value: xPointsStrings[numberOFXPoint])
            numberOFXPoint += 1
        }
    }
    
    func drawStaticLines(chartPath: UIBezierPath, rect: CGRect, heightOfChart: CGFloat, ySpacing: CGFloat)  {
        var currentYLinePoint: CGFloat = 0
        var numberOfLine = 0
        while currentYLinePoint <= heightOfChart {
            chartPath.move(to: CGPoint(x:0,
                                       y:currentYLinePoint))
            if numberOfLine != 0 && isGraphLabelsVisible{
                let yValue = setValueForYRow(currentPoint: chartPath.currentPoint,
                                             heightOfGraph: heightOfChart,
                                             rect: rect, ySpacing: ySpacing)
                addYLabel(point: chartPath.currentPoint,
                          value: yValue)
            }
            chartPath.addLine(to: CGPoint(x: rect.width,
                                          y: currentYLinePoint))
            currentYLinePoint = currentYLinePoint + heightOfChart / 5
            numberOfLine += 1
        }
    }

    func drawGraphicLines(rect: CGRect, heightOfChart: CGFloat, minimalY: Int, ySpacing: CGFloat)  {
        guard let numberOfGraphLines = drawingGraphData?.dataSets.count else { return }
        let xSpaicing = setXSpacing(rect: rect)
        for line in 0...(numberOfGraphLines - 1) {
            let linePath = UIBezierPath()
            let yPoints = drawingGraphData?.dataSets[line].y
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
                let color = UIColor().hexStringToUIColor(hex: drawingGraphData?.dataSets[line].color ?? "#d3d3d3")
                color.set()
                linePath.lineWidth = linesWidth
                linePath.stroke()
            }
            linePath.close()
         }
    }
    
    func addYLinesButtons(graphHeight: CGFloat)  {
        let numberOfButtons = (initialGraphData?.dataSets.count ?? 2) - 1

        for number in 0...numberOfButtons {
            let button = UIButton(frame: CGRect(x: CGFloat(number) * 50 , y: graphHeight + 35, width: 44, height: 44))
            
            let lineName = initialGraphData?.dataSets[number].name
            guard let isButtonEnabled = drawingGraphData?.dataSets.contains(where: { (dataSet) -> Bool in
                dataSet.name == lineName
            }) else { return  }
            if isButtonEnabled {
                button.setTitle("\(initialGraphData?.dataSets[number].name ?? "N/A")", for: .normal)
            } else {
                button.setTitle("Off", for: .normal)
            }
            button.setTitleColor(UIColor().hexStringToUIColor(hex: initialGraphData?.dataSets[number].color ?? "#d3d3d3"), for: .normal)
            button.tag = number
            button.addTarget(self, action: #selector(yLineButtonAction), for: .touchUpInside)
            self.addSubview(button)
        }
    }
    
    @objc func yLineButtonAction(button: UIButton) {
        if button.title(for: .normal) != "Off"{
            if drawingGraphData?.dataSets.count ?? 1 > 1 {
                guard let indexOfLine = drawingGraphData?.dataSets.firstIndex(where: { (dataSet) -> Bool in
                    dataSet.name == initialGraphData?.dataSets[button.tag].name
                }) else { return }
                drawingGraphData?.dataSets.remove(at: indexOfLine)
            } else {
                self.showAlertGraphCountViolation()
            }
        } else {
            button.setTitle("\(initialGraphData?.dataSets[button.tag].name ?? "N/A")", for: .normal)
            drawingGraphData?.dataSets.append((initialGraphData?.dataSets[button.tag])!)
        }
        self.updateUI()
    }
    
    private func showAlertGraphCountViolation() {
        let alert = UIAlertController(title: "Error", message: "At least one graph should be presented", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(okAction)
        self.window?.rootViewController?.present(alert, animated: true, completion: nil)
    }
}
