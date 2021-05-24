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
        self.picker.dataSource = self
        self.picker.delegate = self
    }

    
    func setTestGraph()  {
        let testGraph = GraphView(graphData: chartData!)
        self.view.addSubview(testGraph)
        testGraph.backgroundColor = .white
        testGraph.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            testGraph.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -100),
            testGraph.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 300),
            testGraph.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 5),
            testGraph.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -5)
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
        self.chooseGraphButton.isHidden = true
        self.picker.frame = CGRect(x: self.view.center.x - 100, y: 0, width: 200, height: 200)
        self.okButton.frame = CGRect(x:  self.view.center.x - 50, y: 210, width: 100, height: 50)
        self.view.addSubview(picker)
        self.view.addSubview(okButton)
        self.okButton.setTitle("Ok", for: .normal)
        self.okButton.layer.borderWidth = 2
        self.okButton.layer.borderColor = UIColor.red.cgColor
        self.okButton.layer.cornerRadius = 5
        self.okButton.setTitleColor(.black, for: .normal)
        self.okButton.backgroundColor = .white
        self.okButton.addTarget(self, action: #selector(reloadGraph), for: .touchUpInside)
    }
    
    @objc private func reloadGraph() {
        chartData = jsonDecoder.convertDataToChartModel(chartData: (decodedData?[self.picker.selectedRow(inComponent: 0)])!)
        picker.removeFromSuperview()
        okButton.removeFromSuperview()
        self.chooseGraphButton.isHidden = false
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


