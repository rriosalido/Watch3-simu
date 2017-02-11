//
//  InitialViewController.swift
//  Watch1
//
//  Created by Ricardo Riosalido on 10/2/17.
//  Copyright © 2017 Ricardo Riosalido. All rights reserved.
//

import UIKit

class InitialViewController: UIViewController {

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
        
        let dist = userDefaults.string(forKey: "Dist")
        let flechas = userDefaults.string(forKey: "Flechas")
        let rondas = userDefaults.string(forKey: "Rondas")
        
        print(dist!, rondas!, flechas!)
        
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

}
