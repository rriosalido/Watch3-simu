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

    var session: WCSession!
    
     var dataToSend = [String: Any]()
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        
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
    
    //MARK: WCSession delegate protocol
    
    public func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        //..code
    }
    
    
    @IBAction func AskForSettings() {
        
        print ("Datos Pedidos")
        
        dataToSend["Key"] = "Settings"
        session.sendMessage(dataToSend, replyHandler: { (replyMessage) in
            
            let value = replyMessage["Message"] as? String
            
            print (value)
            
            /*
            if value == "Recibido"{
                self.savedData = true
                self.showPopupOK ("IPhone", "Datos Guardados")
                self.saveButton.setEnabled(false)
                
            } else {
                self.showPopupOK ("Error", "Intentelo de nuevo")
            }
            */
        }) { (error) in
            // Catch any error Handler  REVISAR
            print("error: \(error.localizedDescription)")
            //self.showPopupOK ("Error", "Intentelo de nuevo")
        }
        
        
    }
    
    
}
