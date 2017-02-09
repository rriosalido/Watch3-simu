//
//  ConfigInterfaceController.swift
//  Watch1
//
//  Created by Ricardo Riosalido on 21/1/17.
//  Copyright © 2017 Ricardo Riosalido. All rights reserved.
//

import WatchKit
import Foundation


class ConfigInterfaceController: WKInterfaceController {

    
    //MARK: Variables
    
    var maxRondas = 0
    var maxFlechas = 0
    var distancia = 0
    
    var rondasList: [(String, String)] = [
        ("Item 1", "1"),
        ("Item 2", "2"),
        ("Item 3", "3"),
        ("Item 4", "4"),
        ("Item 5", "5"),
        ("Item 6", "6"),
        ("Item 7", "7"),
        ("Item 8", "8"),
        ("Item 9", "9"),
        ("Item 10", "10"),
        ]
    
    var flechasList: [(String, String)] = [
        ("Item 1", "1"),
        ("Item 2", "2"),
        ("Item 3", "3"),
        ("Item 4", "4"),
        ("Item 5", "5"),
        ("Item 6", "6"),
        ("Item 7", "7"),
        ("Item 8", "8"),
        ("Item 9", "9"),
        ("Item 10", "10"),
        ]
    
    var distList: [(String, String)] = [
        ("Item 1", "18"),
        ("Item 2", "25"),
        ("Item 3", "30"),
        ("Item 4", "50"),
        ("Item 5", "70"),
        ]
    
    //MARK: Outlets
    
    @IBOutlet var rondasPicker: WKInterfacePicker!
    @IBOutlet var flechasPicker: WKInterfacePicker!
    @IBOutlet var distPicker: WKInterfacePicker!
    
    
    //MARK: Inicializacion
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        let pickerItemsRonda: [WKPickerItem] = rondasList.map {
            let pickerItemRonda = WKPickerItem()
            pickerItemRonda.caption = $0.0
            pickerItemRonda.title = $0.1
            return pickerItemRonda
        }
        rondasPicker.setItems(pickerItemsRonda)
        
        
        let pickerItemsFlecha: [WKPickerItem] = flechasList.map {
            let pickerItemFlecha = WKPickerItem()
            pickerItemFlecha.caption = $0.0
            pickerItemFlecha.title = $0.1
            return pickerItemFlecha
        }
        flechasPicker.setItems(pickerItemsFlecha)
        maxRondas = 1
        maxFlechas = 1
      
        let pickerItemsDist: [WKPickerItem] = distList.map {
            let pickerItemDist = WKPickerItem()
            pickerItemDist.caption = $0.0
            pickerItemDist.title = $0.1
            return pickerItemDist
        }
        distPicker.setItems(pickerItemsDist)
        
        maxRondas = 1
        maxFlechas = 1
        distancia = 18
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    //MARK: Actions
    
    @IBAction func setRondas(_ value: Int) {
        maxRondas = Int (rondasList[value].1 )!
        print (maxRondas)
    }
    
    @IBAction func setFlechas(_ value: Int) {
        maxFlechas = Int (flechasList[value].1 )!
        print (maxFlechas )
    }
    
    
    @IBAction func setDist(_ value: Int) {
        distancia = Int (distList[value].1 )!
        print (distancia )
    }
    
    
    @IBAction func startAnotate() {
        
        let config : Any = [maxRondas,maxFlechas,distancia]
        WKInterfaceController.reloadRootControllers(withNames: ["AnotateController"], contexts: [config])
       
      
    }
    
   
    
}
