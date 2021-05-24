//
//  ViewController.swift
//  GraphicsTestApp
//
//  Created by AP Yauheni Hramiashkevich on 5/4/21.
//

import UIKit

class GraphsViewController: UIViewController {
    let jsonDecoder = JsonDecodeManager()
    var decodedData: Responses?
    var chartData: GraphModel? {
        didSet {
            setTestGraph()
        }
    }
    let chooseGraphButton = UIButton()
    let picker = UIPickerView()
    let okButton = UIButton()


    override func viewDidLoad() {
        super.viewDidLoad()
        decodedData = jsonDecoder.decodeJson()
        chartData = jsonDecoder.convertDataToChartModel(chartData: (decodedData?[0])!)
        self.setChooseGraphButton()
    }

    
    func setTestGraph()  {
        guard let chartData = self.chartData else { return }
        let testGraph = GraphView(graphData: chartData)
        self.view.addSubview(testGraph)
        testGraph.backgroundColor = .white
        testGraph.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            testGraph.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -100),
            testGraph.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 300),
            testGraph.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
            testGraph.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0)
            ])
    }
    
    func setChooseGraphButton()  {
        self.view.addSubview(chooseGraphButton)
        self.chooseGraphButton.translatesAutoresizingMaskIntoConstraints = false
        self.chooseGraphButton.backgroundColor = .clear
        self.chooseGraphButton.layer.borderWidth = 2
        self.chooseGraphButton.layer.borderColor = UIColor.red.cgColor
        self.chooseGraphButton.layer.cornerRadius = 5
        self.chooseGraphButton.setTitle("Choose graph", for: .normal)
        self.chooseGraphButton.setTitleColor(.black, for: .normal)
        self.chooseGraphButton.addTarget(self, action: #selector(openGraphPicker), for: .touchUpInside)
        NSLayoutConstraint.activate([
            chooseGraphButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 150),
            chooseGraphButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            chooseGraphButton.heightAnchor.constraint(equalToConstant: 50),
            chooseGraphButton.widthAnchor.constraint(equalToConstant: 300),
            ])
    }
    
    @objc private func openGraphPicker() {
        let alert = UIAlertController(title: "Choose graph", message: "\n\n\n\n\n\n", preferredStyle: .alert)
        picker.frame = CGRect(x: 5, y: 20, width: 250, height: 140)
        alert.view.addSubview(picker)
        picker.dataSource = self
        picker.delegate = self
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
            self.reloadGraph()
        }))
        self.present(alert,animated: true, completion: nil )
    }
    
    @objc private func reloadGraph() {
        chartData = jsonDecoder.convertDataToChartModel(chartData: (decodedData?[self.picker.selectedRow(inComponent: 0)])!)
    }
}

extension GraphsViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return decodedData?.count ?? 1
    }
}

extension GraphsViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(row)"
    }
}


