//
//  ViewController.swift
//  GraphicsTestApp
//
//  Created by AP Yauheni Hramiashkevich on 5/4/21.
//

import UIKit

class ViewController: UIViewController {
    let jsonDecoder = JsonDecodeManager()
    var decodedData: Responses?
    var chartData: ChartModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        decodedData = jsonDecoder.decodeJson()
        chartData = jsonDecoder.convertDataToChartModel(chartData: (decodedData?[1])!)
        self.setTestGraph()
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    func setTestGraph()  {
        let testGraph = ChartView(graphData: (chartData)! )
        self.view.addSubview(testGraph)
        testGraph.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            testGraph.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -400),
            testGraph.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100),
            testGraph.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 5),
            testGraph.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -5)
            ])
    }

}

