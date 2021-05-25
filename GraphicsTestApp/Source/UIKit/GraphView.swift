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
    
    //MARK: Variables
    var graphData: GraphModel? {
        didSet {
            self.drawingGraphData = graphData
            self.updateUI()
        }
    }
    
    private var drawingGraphData: GraphModel?
    let slider = TwoButtonsSlider()
    
    //MARK: Setting
    public var graphLinesColor = UIColor.lightGray
    public var textColor = UIColor.lightGray
    public var linesWidth: CGFloat = 2
    public var staticLinesWidth: CGFloat = 1
    public var isYLabelsVisible: Bool = true
    public var isXLabelsVisible: Bool = true
    public var buttonsAreVisible: Bool = true
    public var sliderIsVisible: Bool = true
    public var yLabelFont: UIFont = UIFont.systemFont(ofSize: 16)
    public var xLabelFont: UIFont = UIFont.systemFont(ofSize: 18)

    
    //MARK: Initializer
    public convenience init(graphData: GraphModel) {
        self.init(frame: CGRect.zero)
        self.graphData = graphData
        self.drawingGraphData = graphData
    }

    //MARK: Drawing function
    public override func draw(_ rect: CGRect) {
        let chartPath = UIBezierPath()
        let heightOfGraph = rect.height - 120
        let widthOfChart = rect.width
        let ySpacing = getYSpacing(heightOfChart: heightOfGraph, type: .dynamicData)
        let minimalY = getMinimalYValue(type: .dynamicData)
        var rangeBetweenXPoint: CGFloat = 60
        let numberOfXLabels = Int(widthOfChart / 120)
        if sliderIsVisible {
            self.addXLineSlider(graphHeight: heightOfGraph)
            self.drawGraphicLines(rect: CGRect(x: 0, y: heightOfGraph + 80, width: rect.width, height: 40), heightOfChart: heightOfGraph + 110, minimalY: getMinimalYValue(type: .staticData), ySpacing: getYSpacing(heightOfChart: 35, type: .staticData), type: .staticData)
        }
        if buttonsAreVisible {
            self.addYLinesButtons(graphHeight: heightOfGraph)
        }
        self.drawStaticLines(chartPath: chartPath, rect: rect,
                             heightOfChart: heightOfGraph,
                             ySpacing: ySpacing)
        if isXLabelsVisible {
            self.setXLabelsWithData(chartPath: chartPath,
                                    numberOfXLabels: numberOfXLabels,
                                    rangeBetweenXPoint: &rangeBetweenXPoint)
        }
        chartPath.close()
        self.graphLinesColor.set()
        chartPath.lineWidth = staticLinesWidth
        chartPath.stroke()
        self.drawGraphicLines(rect: rect,
                              heightOfChart: heightOfGraph,
                              minimalY: minimalY,
                              ySpacing: ySpacing, type: .dynamicData)
      
    }
    
    enum TypeOfGraphic {
        case staticData
        case dynamicData
    }
}

//MARK: Private methods for labels
private extension GraphView {
    
    func addYLabel(point: CGPoint, value: String) {
        let yLabel = UILabel(frame: CGRect(x: point.x + 5,
                                           y: point.y - 20,
                                           width: 100,
                                           height: 20))
        self.addSubview(yLabel)
        yLabel.textColor = textColor
        yLabel.font = yLabelFont
        yLabel.text = value
    }
    
    func addXLabel(point: CGPoint, value: String) {
        let xLabel = UILabel(frame: CGRect(x: point.x,
                                           y: point.y + 5,
                                           width: 100,
                                           height: 20))
        self.addSubview(xLabel)
        xLabel.font = xLabelFont
        xLabel.textColor = textColor
        xLabel.text = value
    }
    
    func setValueForYRow(currentPoint: CGPoint,
                                 heightOfGraph: CGFloat,
                                 rect: CGRect,
                                 ySpacing: CGFloat) -> String {
        var allYValues: [Int] = []
        guard let dataSetCount = drawingGraphData?.dataSets.count else { return "Error" }
        let numberOfLines = dataSetCount - 1
        for y in 0...numberOfLines {
            guard let dataSetYCount = drawingGraphData?.dataSets[y].y.count else { return "Error" }
            let numberOfYPoints = dataSetYCount - 1
            for yPoint in 0...numberOfYPoints {
                guard let dataSetY = drawingGraphData?.dataSets[y].y[yPoint] else { return "Error" }
                allYValues.append(dataSetY)
            }
        }
        let minimalY = allYValues.min() ?? 0
        let yValue = ((heightOfGraph - currentPoint.y) / ySpacing) + CGFloat(minimalY)
        let yValueString = "\(Int(yValue))"
        return yValueString
    }
    
    func setValuesForXRows(numberOfLabels: Int) -> [String] {
        guard let numberOfXs = drawingGraphData?.dataSets[0].x.count else { return ["Error"]}
        var xValues: [String] = []
        let datePercentage = 100 / numberOfLabels
        for number in 1...numberOfLabels {
            let multiplier = Double(datePercentage * number) / 100
            let xForLabel: Int = Int(multiplier * Double(numberOfXs))
            guard let value = drawingGraphData?.dataSets[0].x[xForLabel] else { return ["Unknown"] }
            let date = value.formated(format: "MMM dd")
            xValues.append(date)
        }
        return xValues
    }
}


//MARK: Prive methods for building graphics
private extension GraphView{
    
    func getYSpacing(heightOfChart: CGFloat, type: TypeOfGraphic) -> CGFloat {
        var allYValues: [Int] = []
        let dataSetsCount: Int?
        switch type {
        case .dynamicData:
            dataSetsCount = drawingGraphData?.dataSets.count
            guard let guardDataSetsCount = dataSetsCount else {return 1}
            let numberOfLines = guardDataSetsCount - 1
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
        case .staticData:
            dataSetsCount = graphData?.dataSets.count
            guard let guardDataSetsCount = dataSetsCount else {return 1}
            let numberOfLines = guardDataSetsCount - 1
            for y in 0...numberOfLines {
                let numberOfYPoints = (graphData?.dataSets[y].y.count ?? 1) - 1
                for yPoint in 0...numberOfYPoints {
                    allYValues.append(graphData?.dataSets[y].y[yPoint] ?? 0)
                }
            }
            let minimalY = allYValues.min() ?? 0
            let maximalY = allYValues.max() ?? 1
            let rangeOfYValues = maximalY - minimalY
            let ySpacing = heightOfChart / CGFloat(rangeOfYValues)
            return ySpacing
        }
    }
    
    func getMinimalYValue(type: TypeOfGraphic) -> Int {
        var allYValues: [Int] = []
        let dataSetCount: Int?
        switch type {
        case .dynamicData:
            dataSetCount = drawingGraphData?.dataSets.count
        case .staticData:
            dataSetCount = graphData?.dataSets.count
        }
        guard let guardDataSetsCount = dataSetCount else { return 0 }
        let numberOfLines = guardDataSetsCount - 1
        for y in 0...numberOfLines {
            switch type {
            case .dynamicData:
                let numberOfYPoints = (drawingGraphData?.dataSets[y].y.count ?? 1) - 1
                for yPoint in 0...numberOfYPoints {
                    allYValues.append(drawingGraphData?.dataSets[y].y[yPoint] ?? 0)
                }
            case .staticData:
                let numberOfYPoints = (graphData?.dataSets[y].y.count ?? 1) - 1
                for yPoint in 0...numberOfYPoints {
                    allYValues.append(graphData?.dataSets[y].y[yPoint] ?? 0)
                }
            }
        }
        let minimalY = allYValues.min() ?? 0
        return minimalY
    }
    
    func setXSpacing(rect: CGRect) -> CGFloat {
        guard let dataSetsYsCount = drawingGraphData?.dataSets[0].y.count else { return 1 }
        let numberOfYPoints = dataSetsYsCount - 1
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
        let xPointsForXLabels:[CGFloat] = setPointForXLabels(numberOfXLabels: numberOfXLabels,
                                                             rangeBetweenXPoints: &rangeBetweenXPoint)
        let xPointsStrings = setValuesForXRows(numberOfLabels: xPointsForXLabels.count)
        var numberOFXPoint = 0
        for point in xPointsForXLabels {
            let coordinatesForLabel = CGPoint(x: point,
                                              y: yPointForXLabels)
            self.addXLabel(point: coordinatesForLabel,
                           value: xPointsStrings[numberOFXPoint])
            numberOFXPoint += 1
        }
    }
}

//MARK: Private methods for refreshing view
private extension GraphView {
    
    func removeAllSubview()  {
        for view in self.subviews {
            view.removeFromSuperview()
        }
    }
    
    func updateUI()  {
        self.removeAllSubview()
        self.setNeedsDisplay()
    }
}

//MARK: Private methods for drawing graphics
private extension GraphView {
    
    func drawStaticLines(chartPath: UIBezierPath, rect: CGRect, heightOfChart: CGFloat, ySpacing: CGFloat)  {
        var currentYLinePoint: CGFloat = 0
        var numberOfLine = 0
        while currentYLinePoint <= heightOfChart {
            chartPath.move(to: CGPoint(x:0,
                                       y:currentYLinePoint))
            if numberOfLine != 0 && isYLabelsVisible{
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

    func drawGraphicLines(rect: CGRect, heightOfChart: CGFloat, minimalY: Int, ySpacing: CGFloat, type: TypeOfGraphic)  {
        var dataSetCount: Int?
        switch type {
        case .dynamicData:
            dataSetCount = drawingGraphData?.dataSets.count
        case .staticData:
            dataSetCount = graphData?.dataSets.count
        }
        guard let numberOfGraphLines = dataSetCount else { return }
        let xSpaicing = setXSpacing(rect: rect)
        for line in 0...(numberOfGraphLines - 1) {
            let linePath = UIBezierPath()
            let yPoints: [Int]?
            switch type {
            case .dynamicData:
                yPoints = drawingGraphData?.dataSets[line].y
            case .staticData:
                yPoints  = graphData?.dataSets[line].y
            }
            var xPointer: CGFloat = 0
            guard let initialY = yPoints?[0] else { return }
            let initialYCGPoint = heightOfChart - (CGFloat((initialY - minimalY)) * ySpacing)
            linePath.move(to: CGPoint(x: xPointer, y: initialYCGPoint))
            guard let yPointsCout = yPoints?.count else { return }
            let numberOfYPoints = yPointsCout - 1
            if numberOfYPoints > 0 {
                for yPoint in 1...numberOfYPoints {
                    xPointer += xSpaicing
                    guard let currentY = yPoints?[yPoint] else { return }
                    let yCGPoint = heightOfChart - (CGFloat((currentY - minimalY)) * ySpacing)
                    linePath.addLine(to: CGPoint(x: xPointer, y: yCGPoint))
                    let color: UIColor?
                    switch type {
                    case .dynamicData:
                        color = UIColor().hexStringToUIColor(hex: drawingGraphData?.dataSets[line].color ?? "#d3d3d3")
                    case .staticData:
                        color = UIColor().hexStringToUIColor(hex: graphData?.dataSets[line].color ?? "#d3d3d3")
                    }
                    color?.set()
                    linePath.lineWidth = linesWidth
                    linePath.stroke()
                }
            }
            linePath.close()
         }
    }
}

//MARK: Private methods for adding buttons
private extension GraphView {
    func addYLinesButtons(graphHeight: CGFloat)  {
        guard let dasetCount = graphData?.dataSets.count else { return }
        let numberOfButtons = dasetCount - 1
        for number in 0...numberOfButtons {
            let button = UIButton(frame: CGRect(x: CGFloat(number) * 50 , y: graphHeight + 35, width: 44, height: 44))
            
            let lineName = graphData?.dataSets[number].name
            guard let isButtonEnabled = drawingGraphData?.dataSets.contains(where: { (dataSet) -> Bool in
                dataSet.name == lineName
            }) else { return  }
            if isButtonEnabled {
                button.setTitle("\(graphData?.dataSets[number].name ?? "N/A")", for: .normal)
                button.setTitleColor(UIColor().hexStringToUIColor(hex: graphData?.dataSets[number].color ?? "#d3d3d3"), for: .normal)
            } else {
                button.setTitle("Off", for: .normal)
                button.setTitleColor(.gray, for: .normal)
            }
            button.tag = number
            button.addTarget(self, action: #selector(yLineButtonAction), for: .touchUpInside)
            self.addSubview(button)
        }
    }
    
    @objc func yLineButtonAction(button: UIButton) {
        if button.title(for: .normal) != "Off"{
            guard let dasetsCount = drawingGraphData?.dataSets.count  else { return }
            if dasetsCount > 1 {
                guard let indexOfLine = drawingGraphData?.dataSets.firstIndex(where: { (dataSet) -> Bool in
                    dataSet.name == graphData?.dataSets[button.tag].name
                }) else { return }
                drawingGraphData?.dataSets.remove(at: indexOfLine)
            } else {
                self.showAlertGraphCountViolation()
            }
        } else {
            button.setTitle("\(graphData?.dataSets[button.tag].name ?? "N/A")", for: .normal)
            drawingGraphData?.dataSets.append((graphData?.dataSets[button.tag])!)
        }
        self.updateUI()
    }
    
    func showAlertGraphCountViolation() {
        let alert = UIAlertController(title: "Error", message: "At least one graph should be presented", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(okAction)
        self.window?.rootViewController?.present(alert, animated: true, completion: nil)
    }
}

//MARK: Private methods for adding slider
private extension GraphView {

    func addXLineSlider(graphHeight: CGFloat) {
        slider.frame = CGRect(x: 10 , y: graphHeight + 80, width: self.frame.width - 20, height: 35)
        self.addSubview(slider)
        slider.addTarget(self, action: #selector(onSliderValChanged(slider:event:)), for: [.touchUpInside, .touchUpOutside])
    }
    
    @objc func onSliderValChanged(slider: TwoButtonsSlider, event: UIEvent) {
        guard let numberOfXValues = graphData?.dataSets[0].x.count else { return }
        guard let numberOfGraphs = drawingGraphData?.dataSets.count else { return }
        let currentLowerValue = Int(slider.lowerValue * CGFloat(numberOfXValues - 1))
        let currentUpperValue = Int(slider.upperValue * CGFloat(numberOfXValues - 1))
                for number in 0...(numberOfGraphs - 1) {
                    let graphName = drawingGraphData?.dataSets[number].name
                    guard let numberOfDataSets = graphData?.dataSets.count else {return }
                    for graph in 0...(numberOfDataSets - 1) {
                        if graphData?.dataSets[graph].name == graphName {
                            guard let newXRange = graphData?.dataSets[graph].x[currentLowerValue...currentUpperValue] else { return }
                            let newXRangeArray = Array<Date>(newXRange)
                            guard let newYRange = graphData?.dataSets[graph].y[currentLowerValue...currentUpperValue] else { return }
                            let newYRangeArray = Array<Int>(newYRange)
                            drawingGraphData?.dataSets[number].x = newXRangeArray
                            drawingGraphData?.dataSets[number].y = newYRangeArray
                        }
                    }
                }
            self.updateUI()
    }
}


