//
//  SettingsViewController.swift
//  Watch1
//
//  Created by Ricardo Riosalido on 10/2/17.
//  Copyright © 2017 Ricardo Riosalido. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    
    //MARK: Variables
    
    var dist = ""
    var rondas = ""
    var flechas = ""
    let userDefaults = UserDefaults.standard
  
    var pickerData: [[String]] = [[String]]()
    
    //MARK: Outlets
    
    @IBOutlet weak var picker: UIPickerView!
    
    //MARK: Initialize
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.picker.dataSource = self
        self.picker.delegate = self
        
        pickerData  = [["18m","25m","30m", "50m", "70m"],
                       ["1","2","3","4","5","6","7","8","9","10"],
                       ["1","2","3","4","5","6","7","8","9","10"] ]
        
        dist = (userDefaults.string(forKey: "Dist")!)
        let index = pickerData[0].index(of: dist)
        rondas = (userDefaults.string(forKey: "Rondas")!)
        flechas = (userDefaults.string(forKey: "Flechas")!)
        
        print (dist,rondas,flechas)
        
        picker.selectRow(index!, inComponent: 0, animated: true)
        picker.selectRow(Int(rondas)!-1, inComponent: 1, animated: true)
        picker.selectRow(Int(flechas)!-1, inComponent: 2, animated: true)
        
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
    
    //MARK: Catpure the picker view selection
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // This method is triggered whenever the user makes a change to the picker selection.
        // The parameter named row and component represents what was selected.
        
        
        switch component {
        case 0:
            dist = pickerData [0] [row]
            userDefaults.set(dist, forKey: "Dist")
        case 1 :
            rondas = pickerData[1] [row]
            userDefaults.set(rondas, forKey: "Rondas")
        case 2 :
            flechas = pickerData[2] [row]
            userDefaults.set(flechas, forKey: "Flechas")
        default: break
        }
        
        print (dist, rondas, flechas)
    }
    
    
    
}
