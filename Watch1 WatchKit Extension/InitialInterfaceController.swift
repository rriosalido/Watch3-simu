//
//  InitialInterfaceController.swift
//  Watch1
//
//  Created by Ricardo Riosalido on 12/2/17.
//  Copyright © 2017 Ricardo Riosalido. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity


class InitialInterfaceController: WKInterfaceController, WCSessionDelegate {

    
    //MARK: Variables
    
    var session: WCSession!
    var distancia = ""
    var maxRondas = ""
    var maxFlechas = ""
    var dataToSend = [String: Any]()
    
    //MARK: Outlets
    
    @IBOutlet var rondasLabel: WKInterfaceLabel!
    
    @IBOutlet var distLabel: WKInterfaceLabel!
    
    @IBOutlet var flechasLabel: WKInterfaceLabel!
    
    @IBOutlet var startButton: WKInterfaceButton!
    
    //MARK: Initiallize
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        
        if WCSession.isSupported() {
            session = WCSession.default()
            session.delegate = self
            session.activate()
            
            print ("Activada Sesion")
            
            startButton.setEnabled(false)
    
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
    
    //MARK: WCSession delegate protocol
    
    public func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        //..code
    }
    
    
    //MARK: Actions
    
    @IBAction func AskForSettings() {
        
        print ("Datos Pedidos")
        
        dataToSend["Key"] = "Settings"
        session.sendMessage(dataToSend, replyHandler: { (replyMessage) in
            
            let value = replyMessage["Message"] as? String
            
            let arrayString = value?.components(separatedBy: ",")
            self.distancia = (arrayString?[0])!
            self.maxRondas = (arrayString?[1])!
            self.maxFlechas = (arrayString?[2])!
            
            //print (value)
            print (self.distancia,self.maxRondas, self.maxFlechas)
            
            self.distLabel.setText("Distancia: " + self.distancia)
            self.rondasLabel.setText("Nº de Rondas: " + self.maxRondas)
            self.flechasLabel.setText("Nº de Flechas: " + self.maxFlechas)
            
            self.startButton.setEnabled(true)
            
        }) { (error) in
            // Catch any error Handler  REVISAR
            print("error: \(error.localizedDescription)")
            //self.showPopupOK ("Error", "Intentelo de nuevo")
        }
        
        
    }
    
    
    @IBAction func startTirada() {
        
        let rondas = Int(maxRondas)
        let flechas = Int(maxFlechas)
        
        let index = distancia.index(distancia.startIndex, offsetBy: 2)
        let dist = Int(distancia.substring(to: index))
    
        let config : Any = [rondas,flechas,dist]
        WKInterfaceController.reloadRootControllers(withNames: ["AnotateController"], contexts: [config])
        
        
    }
  
    @IBAction func exitButton() {
        exit(0)
    }
    
}
