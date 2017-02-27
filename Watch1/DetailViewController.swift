
//
//  DetailViewController.swift
//  Watch1
//
//  Created by Ricardo Riosalido on 26/1/17.
//  Copyright © 2017 Ricardo Riosalido. All rights reserved.
//

import UIKit
import Charts


class DetailViewController: UIViewController {

    //MARK: Variables
    
    var myshot = ShotDB()
    
    
    //MARK: Outlets
    
    @IBOutlet weak var fechaLabel: UILabel!
    @IBOutlet weak var distLabel: UILabel!
    @IBOutlet weak var tirosLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var mediaLabel: UILabel!
    @IBOutlet weak var destLabel: UILabel!
    @IBOutlet weak var barChartView: BarChartView!
    
    @IBOutlet weak var pieChartView: PieChartView!
    
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    //MARK: Initialize
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fecha = decodeDate(myshot.fecha)
        
        fechaLabel.text = fecha
        distLabel.text = "Dist= " + myshot.dist
        tirosLabel.text = "Tiros= "+String(myshot.tiros)
        mediaLabel.text = "Media= "+String(myshot.media)
        totalLabel.text = "Total= "+String(myshot.total)
        destLabel.text = "Desv.T.= "+String(myshot.std)
        
        let string = myshot.puntos
        let arrayString = string.components(separatedBy: "-")
        let table = arrayString.map{Int($0)!}
        
        barChartView.isHidden = false
        pieChartView.isHidden = true
        
        setChart(values: table, media: myshot.media)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: Chart 
    
    func setChart(values: [Int], media: Double) {
    
        
        var dataEntries: [BarChartDataEntry] = []
        var pieEntries: [ChartDataEntry] = []
        
        var freq : Double                   // freq %
        let num = values.reduce(0, _:+)
        
        for i in 0..<values.count {

            freq = (Double(values[i]) / Double(num))*100.0
            //let dataEntry = BarChartDataEntry(x: Double(i), y: Double(values[i]))  // freq abosultas
            let dataEntry = BarChartDataEntry(x: Double(i), y: freq)
            let pieEntry = ChartDataEntry(x: Double(i), y: freq)
            dataEntries.append(dataEntry)
            pieEntries.append(pieEntry)
        }
        
        // BarChart
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "Tiros")
        let chartData = BarChartData(dataSet: chartDataSet)
        barChartView.data = chartData
        barChartView.chartDescription?.text = nil
        //chartDataSet.colors = ChartColorTemplates.colorful()
        //chartDataSet.colors = [.green, .white, .lightGray,.darkGray,.black,.cyan,.blue,.magenta,.red,.yellow,.orange,.brown]
        chartDataSet.colors = [.green, .white, .white, .black,.black,.blue,.blue,.red,.red,.yellow,.yellow,.yellow]
        let labels = ["M","1","2","3","4","5","6","7","8","9","10","X"]
        barChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: labels)
        barChartView.xAxis.granularityEnabled = true
        barChartView.xAxis.granularity = 1
        barChartView.xAxis.labelPosition = .bottom
        barChartView.leftAxis.axisMinimum = 0.0
        barChartView.rightAxis.axisMinimum = 0.0
        barChartView.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
        let ll = ChartLimitLine(limit: media, label: "Media")
        barChartView.rightAxis.addLimitLine(ll)
        barChartView.legend.enabled = false
        
        //barChartView.scaleYEnabled = false
        //barChartView.scaleXEnabled = false
        //barChartView.pinchZoomEnabled = false
        //barChartView.doubleTapToZoomEnabled = false
        //barChartView.highlighter = nil
        //barChartView.rightAxis.enabled = false
        //barChartView.leftAxis.enabled = false
        //barChartView.xAxis.drawGridLinesEnabled = false   
        
        //Pie
        let pieChartDataSet = PieChartDataSet(values: pieEntries, label: "Frecuencia %")
        
        pieChartDataSet.xValuePosition = PieChartDataSet.ValuePosition(rawValue: 1)!
        pieChartDataSet.yValuePosition = PieChartDataSet.ValuePosition(rawValue: 1)!
        pieChartDataSet.valueLineColor = .white
        pieChartDataSet.valueLineWidth = 1.5
        pieChartDataSet.colors = [.green, .white, .lightGray,.darkGray,.black,.cyan,.blue,.magenta,.red,.yellow,.orange,.brown]
        
        
        // -------- Esto no me funciona
        pieChartDataSet.entryLabelColor = NSUIColor.blue
        pieChartDataSet.entryLabelFont = NSUIFont.boldSystemFont(ofSize: 20)
        // --------
        
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        
        
        pieChartView.chartDescription?.text = ""
        
        pieChartView.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
        pieChartView.legend.enabled = true
        pieChartView.legend.textColor = .black
        pieChartView.legend.font = NSUIFont.boldSystemFont(ofSize: 15)
        pieChartView.legend.formSize = 12.0
        
        
        pieChartView.holeColor = UIColor.clear
        
        pieChartView.centerText = "Media= "+String(myshot.media)+"\n"+"Desv.T.= "+String(myshot.std)
        // --------Esto Tampoco funciona
        pieChartView.drawEntryLabelsEnabled = true
        pieChartView.entryLabelColor = NSUIColor.black
        pieChartView.entryLabelFont = NSUIFont.boldSystemFont(ofSize: 5)
        // --------
        
        
        pieChartView.data = pieChartData
    }
    
    
    @IBAction func chartSelect(_ sender: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex
        {
        case 0:
            //textLabel.text = "First selected";
            barChartView.isHidden = false
            pieChartView.isHidden = true
        case 1:
            //textLabel.text = "Second Segment selected";
            barChartView.isHidden = true
            pieChartView.isHidden = false
        default:
            break;
        }
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
