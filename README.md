# ChartTestView

This library is created to help draw graphs.
Graph is drawing based on the model [DataSet] in which each DataSet is
```
public struct DataSet {
    var x: [Date]
    var y: [Int]
    var name: String
    var color: String
}
```
Number of x and y in arrays should be equal in each DataSet for one graph.
# Add library to project: 



# Settings for graphs:
    graphLinesColor
    textColor
    linesWidth
    staticLinesWidth
    isYLabelsVisible
    isXLabelsVisible
    buttonsAreVisible
    sliderIsVisible
    yLabelFont
    xLabelFont
    
# How to use: 

Use  GraphView convinience init and set it with [DataSet]

Example: 
```
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
 ```
