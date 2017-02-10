//
//  SettingsViewController.swift
//  Watch1
//
//  Created by Ricardo Riosalido on 10/2/17.
//  Copyright © 2017 Ricardo Riosalido. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    var dist = ""
    var rondas = ""
    var flechas = ""
    
    
    var pickerData: [[String]] = [[String]]()
    
    
    @IBOutlet weak var picker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
        self.picker.dataSource = self
        self.picker.delegate = self
        
        pickerData  = [["18m","30m", "50m", "70m"],
                       ["1","2","3","4","5","6","7","8","9","10"],
                       ["1","2","3","4","5","6","7","8","9","10"] ]
        
        picker.selectRow(2, inComponent: 0, animated: true)
        picker.selectRow(5, inComponent: 1, animated: true)
        picker.selectRow(9, inComponent: 2, animated: true)
        dist = "50m"
        rondas = "6"
        flechas = "10"
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // The number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData[component].count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[component][row]
    }
    
    // Catpure the picker view selection
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // This method is triggered whenever the user makes a change to the picker selection.
        // The parameter named row and component represents what was selected.
        
        
        switch component {
        case 0:
            dist = pickerData [0] [row]
        case 1 :
            rondas = pickerData[1] [row]
        case 2 :
            flechas = pickerData[2] [row]
            
        default: break
            
        }
        
        print (dist, rondas, flechas)
    }
    
    
    func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
        return CGRect(x: x, y: y, width: width, height: height)
    }
}
