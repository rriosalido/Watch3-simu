//
//  AnotateInterfaceController.swift
//  Watch1 WatchKit Extension
//
//  Created by Ricardo Riosalido on 17/1/17.
//  Copyright © 2017 Ricardo Riosalido. All rights reserved.
//

import WatchKit
import Foundation



class AnotateInterfaceController: WKInterfaceController {
    
    //MARK: Variables
    
    var maxRondas = 0
    var maxFlechas = 0
    var numShots = 0
    var ronda = 1
    var puntosTirada = [String]()
    var tiradas = [[String]()]
    var labelScore = " "
    var distancia = 0
    var config = [Int]()
    
    // MARK: Outlets
    
    @IBOutlet var buttonX: WKInterfaceButton!
    @IBOutlet var button10: WKInterfaceButton!
    @IBOutlet var button9: WKInterfaceButton!
    @IBOutlet var button8: WKInterfaceButton!
    @IBOutlet var button7: WKInterfaceButton!
    @IBOutlet var button6: WKInterfaceButton!
    @IBOutlet var button5: WKInterfaceButton!
    @IBOutlet var button4: WKInterfaceButton!
    @IBOutlet var button3: WKInterfaceButton!
    @IBOutlet var button2: WKInterfaceButton!
    @IBOutlet var button1: WKInterfaceButton!
    @IBOutlet var buttonM: WKInterfaceButton!
    @IBOutlet var next: WKInterfaceButton!
    @IBOutlet var parcialScore: WKInterfaceLabel!
    @IBOutlet var numRonda: WKInterfaceLabel!
    @IBOutlet var clearLast: WKInterfaceButton!
    @IBOutlet var endButton: WKInterfaceButton!
    
    
    //MARK: Inicializacion
    
    override func awake(withContext context: Any?) {

        super.awake(withContext: context)
        
        config = context as! [Int]
        self.maxRondas = config[0]
        self.maxFlechas = config[1]
        self.distancia = config[2]
        tiradas[0]=[String(distancia)+"m"]
        
        next.setEnabled(false)
        endButton.setEnabled(false)
        numRonda.setText("1" + " de " + String(self.maxRondas))
        parcialScore.setText(labelScore)
        clearLast.setEnabled(false)
       
        
        
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
    
    @IBAction func pressX() {numberPressed("X")}
    @IBAction func press10() {numberPressed("10")}
    @IBAction func press9() {numberPressed("9")}
    @IBAction func press8() {numberPressed("8")}
    @IBAction func press7() {numberPressed("7")}
    @IBAction func press6() {numberPressed("6")}
    @IBAction func press5() {numberPressed("5")}
    @IBAction func press4() {numberPressed("4")}
    @IBAction func press3() {numberPressed("3")}
    @IBAction func press2() {numberPressed("2")}
    @IBAction func press1() {numberPressed("1")}
    @IBAction func pressM() {numberPressed("M")}
    
    @IBAction func nextRonda() {
        print ("Next Ronda")
        ronda += 1
       
        if ronda > maxRondas {
            next.setEnabled(false)
            WKInterfaceController.reloadRootControllers(withNames: ["ResultsController"], contexts: [tiradas])
            
        } else {
            numRonda.setText(String(ronda) + " de " + String(self.maxRondas))
            next.setEnabled(false)
            endButton.setEnabled(false)
            enableButtons()
            numShots = 0
            puntosTirada = []
            labelScore = " "
            parcialScore.setText(labelScore)
        }
    }
    
    func numberPressed (_ value : String){
      
        numShots += 1
        puntosTirada.append(value)
        labelScore = listaRonda(puntosTirada)
        print (labelScore)
        parcialScore.setText(labelScore)
        clearLast.setEnabled(true)
        if numShots == maxFlechas {
            disableButtons()
            tiradas.append(puntosTirada)
            print (tiradas)
            let suma = sumaRonda(puntosTirada)
            labelScore.remove(at: labelScore.index (before: labelScore.endIndex))
            labelScore = labelScore + "=" + String(suma)
            parcialScore.setText(labelScore)
            if ronda == maxRondas {
                next.setEnabled(false)
            } else {
                next.setEnabled(true)
            }
             endButton.setEnabled(true)
        }
        
    }
    
    
    @IBAction func deleteLast() {
        
        if numShots == maxFlechas {
            tiradas.remove(at: (tiradas.count) - 1)
            print (tiradas)
        }
        numShots -= 1
        puntosTirada.remove(at: numShots)
        labelScore = listaRonda(puntosTirada)
        if labelScore.characters.count == 0 {
            labelScore = " "
            clearLast.setEnabled(false)
        }
        parcialScore.setText(labelScore)
        enableButtons()
        endButton.setEnabled(false)
        next.setEnabled(false)
   
    }
    
    
    
    @IBAction func endTirada() {
        // no se llega al maximo de tiradas, pero se finaliza
        // pasa directamente a resultados
        ronda = maxRondas
        nextRonda()
    }
    
    func disableButtons (){
        button1.setEnabled(false)
        button2.setEnabled(false)
        button3.setEnabled(false)
        button4.setEnabled(false)
        button5.setEnabled(false)
        button6.setEnabled(false)
        button7.setEnabled(false)
        button8.setEnabled(false)
        button9.setEnabled(false)
        button10.setEnabled(false)
        buttonM.setEnabled(false)
        buttonX.setEnabled(false)
    }

    func enableButtons(){
        button1.setEnabled(true)
        button2.setEnabled(true)
        button3.setEnabled(true)
        button4.setEnabled(true)
        button5.setEnabled(true)
        button6.setEnabled(true)
        button7.setEnabled(true)
        button8.setEnabled(true)
        button9.setEnabled(true)
        button10.setEnabled(true)
        buttonM.setEnabled(true)
        buttonX.setEnabled(true)
    }
    
}
