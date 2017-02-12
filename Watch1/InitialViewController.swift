//
//  InitialViewController.swift
//  Watch1
//
//  Created by Ricardo Riosalido on 10/2/17.
//  Copyright © 2017 Ricardo Riosalido. All rights reserved.
//

import UIKit
import RealmSwift
import WatchConnectivity


class InitialViewController: UIViewController, WCSessionDelegate {
    
    //MARK: Variables
    
    var session : WCSession!
    var dist = ""
    var flechas = ""
    var rondas = ""
    
    //MARK: Inicializacion
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
     
        let userDefaults = UserDefaults.standard
        
        if userDefaults.string(forKey: "Dist") == nil {
            userDefaults.set("30m", forKey: "Dist")
        }
        
        if userDefaults.string(forKey: "Rondas") == nil {
            userDefaults.set("8", forKey: "Rondas")
        }
        
        if userDefaults.string(forKey: "Flechas") == nil {
            userDefaults.set("6", forKey: "Flechas")
  
        }
        
        dist = userDefaults.string(forKey: "Dist")!
        flechas = userDefaults.string(forKey: "Flechas")!
        rondas = userDefaults.string(forKey: "Rondas")!
        
        print(dist, rondas, flechas)
        
        if WCSession.isSupported() {
            session = WCSession.default()
            session.delegate = self
            session.activate()
            print ("Sesion Activada")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    //MARK: WCSession Delegate
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        
        let key = message["Key"] as? String
        
        if key == "Settings" {
            
            let userDefaults = UserDefaults.standard
            dist = userDefaults.string(forKey: "Dist")!
            flechas = userDefaults.string(forKey: "Flechas")!
            rondas = userDefaults.string(forKey: "Rondas")!
            let dataToSend = dist+","+rondas+","+flechas
            replyHandler(["Message": dataToSend])
            
        } else {
            
            let date = message["Fecha"] as? Date
            let dist = message["Dist"] as? String
            let stable = message["Tabla"] as? String
            
            let mystatS = statS(stable!)
            
            let mydata = ShotDB()
            mydata.fecha = date!
            mydata.dist = dist!
            mydata.total = mystatS.total
            mydata.media = mystatS.media
            mydata.tiros = mystatS.tiros
            mydata.std = mystatS.std
            mydata.puntos = stable!
            
            let realm = try! Realm()
            
            try! realm.write {
                realm.add(mydata)
                print ("Añadido Registro")
            }
            //print(Realm.Configuration.defaultConfiguration.fileURL!)
            replyHandler(["Message":"Recibido"])
        }
    }
    
    public func sessionDidDeactivate(_ session: WCSession) {
        //..
    }
    
    public func sessionDidBecomeInactive(_ session: WCSession) {
        //..
    }
    
    public func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        //..
    }
    
    
    
}
