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
    
    var session : WCSession!
    
    
    var dist = ""
    var flechas = ""
    var rondas = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let userDefaults = UserDefaults.standard
        
        //let userDefaults = UserDefaults(suiteName: "group.Watch1.settings")
        
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
            
            //dataToSend["Rondas"] = rondas
            //dataToSend["Flechas"] = flechas
            //dataToSend["Dist"] = dist
            
            
            //var dataToSend = [dist,rondas,flechas]
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
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        /*
        DispatchQueue.main.async { () -> Void in
            self.tableView.reloadData()
        }
        // GCD - Present on the screen
        /*
         DispatchQueue.main.async { () -> Void in
         self.mediaLabel.text = "Media: " + String(media)
         self.tirosLabel.text = "Tiros: " + String(tiros)
         self.destLabel.text = "Sigma: " + String(dest)
         self.fechaLabel.text = "Fecha: " + fecha
         self.distLabel.text = "Distancia: " + dist!
         self.totalLabel.text = "Total: " + String(total)
         }
         */
        */
        // Send a reply
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
