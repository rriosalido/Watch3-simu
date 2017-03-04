//
//  LineViewController.swift
//  pepe
//
//  Created by Ricardo Riosalido on 20/2/17.
//  Copyright © 2017 Ricardo Riosalido. All rights reserved.
//

import UIKit
import RealmSwift
import Charts

class LineViewController: UIViewController {
    
    //MARK: Variables
    
    let realm = try! Realm()
    let dataDB = try! Realm().objects(ShotDB.self).sorted(byKeyPath: "fecha", ascending: true)
    var fileURL : URL!
    
    //MARK: Outlets
    
    @IBOutlet weak var lineChartView: LineChartView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    //MARK: Initialize
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let realmFile = Realm.Configuration.defaultConfiguration.fileURL!
        print (realmFile)
        
        if dataDB.count > 0 {
            print (dataDB.count)
            var data = getData(dataDB)
            data = sumaDiasDuplicados(data)
            self.segmentedControl.selectedSegmentIndex = 5
            setChart(data)
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: Chart
    
    func setChart(_ data: [dataG]) {
        
        var dataEntries: [ChartDataEntry] = []
        var upEntries: [ChartDataEntry] = []
        var doEntries: [ChartDataEntry] = []
        var labels = [String]()
        
        for i in 0..<data.count {
            let dataEntry = ChartDataEntry(x: Double(i), y: data[i].media)
            let std = data[i].std
            let upEntry = ChartDataEntry(x:Double(i), y:(data[i].media)+std)
            let doEntry = ChartDataEntry(x:Double(i), y:(data[i].media)-std)
            var label = data[i].dia
            label = label.replacingOccurrences(of: "/20", with: "/")
            dataEntries.append(dataEntry)
            upEntries.append(upEntry)
            doEntries.append(doEntry)
            labels.append(label)
        }
        
        
        let lineChartDataSet = LineChartDataSet(values: dataEntries, label: "Media")
        lineChartDataSet.setCircleColor(UIColor.blue) // our circle will be dark red
        lineChartDataSet.lineWidth = 3.0
        lineChartDataSet.circleRadius = 4.0 // the radius of the node circle
        lineChartDataSet.fillAlpha = 1
        lineChartDataSet.fillColor = UIColor.black
        lineChartDataSet.highlightColor = UIColor.black
        lineChartDataSet.drawCircleHoleEnabled = true
        lineChartDataSet.setColor(.red)

        let upChartDataSet = LineChartDataSet(values: upEntries, label: "+STD")
        upChartDataSet.setCircleColor(UIColor.blue) // our circle will be dark red
        upChartDataSet.lineWidth = 1.0
        upChartDataSet.circleRadius = 0.0 // the radius of the node circle
        upChartDataSet.fillAlpha = 1
        upChartDataSet.fillColor = UIColor.black
        upChartDataSet.highlightColor = UIColor.black
        upChartDataSet.drawCircleHoleEnabled = false
        upChartDataSet.setColor(.blue)
        
        let doChartDataSet = LineChartDataSet(values: doEntries, label: "-STD")
        doChartDataSet.setCircleColor(UIColor.blue) // our circle will be dark red
        doChartDataSet.lineWidth = 1.0
        doChartDataSet.circleRadius = 0.0 // the radius of the node circle
        doChartDataSet.fillAlpha = 1
        doChartDataSet.fillColor = UIColor.black
        doChartDataSet.highlightColor = UIColor.black
        doChartDataSet.drawCircleHoleEnabled = false
        doChartDataSet.setColor(.green)
        
        
        lineChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: labels)
        
        lineChartView.xAxis.granularityEnabled = true
        lineChartView.xAxis.granularity = 3.0
        
        lineChartView.leftAxis.axisMinimum = 0.0
        lineChartView.leftAxis.axisMaximum = 10.5
        lineChartView.rightAxis.axisMinimum = 0.0
        lineChartView.rightAxis.axisMaximum = 10.5
        
        //lineChartView.drawMarkers = true
        //lineChartView.marker =
        
        var dataSets : [LineChartDataSet] = [LineChartDataSet]()
        dataSets.append(lineChartDataSet)
        dataSets.append(upChartDataSet)
        dataSets.append(doChartDataSet)
        
        let data: LineChartData = LineChartData(dataSets: dataSets)
        
        lineChartView.data = data
        lineChartView.isHidden = false
        
    }
    
    
    
    @IBAction func indexChanged(_ sender: UISegmentedControl) {
        
        let results : Results<ShotDB>
        
        switch (self.segmentedControl.selectedSegmentIndex)   {
            
        case 0:
            results = self.dataDB.filter("dist = '18m'")
            break;
        case 1:
            results = self.dataDB.filter("dist = '25m'")
            break;
        case 2:
            results = self.dataDB.filter("dist = '30m'")
            break;
        case 3:
            results = self.dataDB.filter("dist = '50m'")
            break;
        case 4:
            results = self.dataDB.filter("dist = '70m'")
            break;
        default:
            results = self.dataDB
            break
        }
        var data = getData(results)
        
        if data.count > 0 {
            data = sumaDiasDuplicados(data)
            setChart(data)
        } else {
            lineChartView.isHidden = true
        }
        
    }
    
    
    func getData (_ results: Results<ShotDB>) -> [dataG] {
        var data = [dataG]()
        for i in 0..<results.count {
            data.append(dataG(dia:decodeDate(results[i].fecha),media:results[i].media,std:results[i].std,tiros:results[i].tiros))
        }
        return data
    }
    
    func sumaDiasDuplicados(_ data: [dataG]) -> [dataG] {
        
        var newdata = [dataG]()
        newdata.append(data[0])
        
        for i in 0..<(data.count)-1  {
            let j = (newdata.count) - 1
            let dia1 = newdata[j].dia
            let dia2 = data[i+1].dia
            
            if dia1 == dia2 {
                
                let media1 = newdata[j].media
                let n1 = Double(newdata[j].tiros)
                let std1 = newdata[j].std
                let media2 = data[i+1].media
                let n2 = Double(data[i+1].tiros)
                let std2 = data[i+1].std
                
                let mymedia = ((media1*n1)+(media2*n2))/(n1+n2)
                let s1 = (pow(std1,2)*n1)+(pow(std2,2)*n2)
                let s2 = (pow((media1-mymedia),2))*n1
                let s3 = (pow((media2-mymedia),2))*n2
                let s = (s1+s2+s3)/(n1+n2)
                let mystd = sqrt(s)
                
                newdata[j].media = mymedia
                newdata[j].std = mystd
                newdata[j].tiros = Int(n1+n2)
                
            } else {
                newdata.append(data[i+1])
            }
            
        }
        
        return newdata
        
    }    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

