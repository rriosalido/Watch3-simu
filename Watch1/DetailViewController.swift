
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
        
        setChart(values: table, media: myshot.media)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: Chart 
    
    func setChart(values: [Int], media: Double) {
        barChartView.noDataText = "You need to provide data for the chart."
        
        var dataEntries: [BarChartDataEntry] = []
        
        var freq : Double                   // freq %
        let num = values.reduce(0, _:+)
        
        for i in 0..<values.count {

            freq = (Double(values[i]) / Double(num))*100.0
            //let dataEntry = BarChartDataEntry(x: Double(i), y: Double(values[i]))  // freq abosultas
            let dataEntry = BarChartDataEntry(x: Double(i), y: freq)
            dataEntries.append(dataEntry)
        }
        

        let chartDataSet = BarChartDataSet(values: dataEntries, label: "Tiros")
 
        let chartData = BarChartData(dataSet: chartDataSet)
        
        barChartView.data = chartData
        
        barChartView.chartDescription?.text = nil
        
        //chartDataSet.colors = ChartColorTemplates.colorful()
        
        
        chartDataSet.colors = [.green, .white, .white, .black,.black,.blue,.blue,.red,.red,.yellow,.yellow,.yellow]
        
        
        
        
        let labels = ["M","1","2","3","4","5","6","7","8","9","10","X"]
        barChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: labels)
        barChartView.xAxis.granularityEnabled = true
        barChartView.xAxis.granularity = 1
        barChartView.xAxis.labelPosition = .bottom
        barChartView.leftAxis.axisMinimum = 0.0
        barChartView.rightAxis.axisMinimum = 0.0
        
        
        //barChartView.backgroundColor = UIColor(red: 189/255, green: 195/255, blue: 199/255, alpha: 1)
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
