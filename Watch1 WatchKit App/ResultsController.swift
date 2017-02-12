//
//  ResultsControllerInterfaceController.swift
//  Watch1
//
//  Created by Ricardo Riosalido on 19/1/17.
//  Copyright © 2017 Ricardo Riosalido. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity


class ResultsController: WKInterfaceController, WCSessionDelegate {
    
    //MARK: Properties
    
    var session: WCSession!
    var savedData = false
    var dataToSend = [String: Any]()
    let date = Date()
    var tiradas = [[String]()]
    
  
    //MARK: Outlets
    
    @IBOutlet var distLabel: WKInterfaceLabel!
    @IBOutlet var tirosLabel: WKInterfaceLabel!
    @IBOutlet var totalLabel: WKInterfaceLabel!
    @IBOutlet var mediaLabel: WKInterfaceLabel!
    @IBOutlet var sigmaLabel: WKInterfaceLabel!
    @IBOutlet var saveButton: WKInterfaceButton!
    @IBOutlet var againButton: WKInterfaceButton!
    
    
    //MARK: Inicializacion
    
    override func awake(withContext context: Any? ) {
        super.awake(withContext: context)
        
        let tiradas = context as! [[String]]
       
        //Calculamos los estadísticos y los visualizamos
        
        let tabla = tablaFreq(tiradas)
        
        let arrayString = tabla.map {String($0)}
        let stabla = arrayString.joined(separator: "-")
        let dist = tiradas[0][0]
        
        let myshot = statS(stabla)
        
        distLabel.setText(dist)
        tirosLabel.setText(String(myshot.tiros))
        totalLabel.setText(String(myshot.total))
        mediaLabel.setText(String(myshot.media))
        sigmaLabel.setText(String(myshot.std))
        
        dataToSend["Fecha"] = date
        dataToSend["Dist"] = dist

        dataToSend["Tabla"] = stabla
        
        print (dataToSend)
        
        if WCSession.isSupported() {
            session = WCSession.default()
            session.delegate = self
            session.activate()
            
            print ("Activada Sesion")
        }
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
    
    @IBAction func again() {
        WKInterfaceController.reloadRootControllers(withNames: ["InitialInterfaceController"], contexts: nil)
    }
    
    @IBAction func exitButtom() {
        if savedData {
            exit(0)
        } else {
            showPopup2()
        }
    }


    @IBAction func saveData() {
        
        transmitData()
        
    }
    
    //MARK: WCSession delegate protocol
    
    public func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        //..code
    }
    
    
    //MARK: Funciones
    
    func transmitData () {
        
        print ("Datos transmitidos")
        
        session.sendMessage(dataToSend, replyHandler: { (replyMessage) in
            
            let value = replyMessage["Message"] as? String
            
            //print (value)
            
            if value == "Recibido"{
                self.savedData = true
                self.showPopupOK ("IPhone", "Datos Guardados")
                self.saveButton.setEnabled(false)
                
            } else {
                self.showPopupOK ("Error", "Intentelo de nuevo")
            }
            
        }) { (error) in
            // Catch any error Handler  REVISAR
            print("error: \(error.localizedDescription)")
            self.showPopupOK ("Error", "Intentelo de nuevo")
        }
    }
    
    
    func showPopupOK(_ title : String, _ message: String){
        let h0 = { print("ok")}
        let action1 = WKAlertAction(title: "OK", style: .default, handler:h0)
        presentAlert(withTitle: title, message: message, preferredStyle: .alert, actions: [action1])
    }
    
    func showPopup2(){
        let h0 = { self.transmitData() }
        let action1 = WKAlertAction(title: "SI", style: .default, handler:h0)
        let action2 = WKAlertAction(title: "NO", style: .default) {exit(0)}
        presentAlert(withTitle: "IPhone", message: "¿Desea guardar los datos?", preferredStyle: .sideBySideButtonsAlert, actions: [action1,action2])
    }
}




    
    
    

