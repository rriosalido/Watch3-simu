//
//  TableTableViewController.swift
//  Watch1
//
//  Created by Ricardo Riosalido on 26/1/17.
//  Copyright © 2017 Ricardo Riosalido. All rights reserved.
//

import UIKit
import WatchConnectivity
import RealmSwift

class TableViewCell : UITableViewCell{
    
    
    @IBOutlet weak var fechaLabel: UILabel!
    @IBOutlet weak var distLabel: UILabel!
    @IBOutlet weak var tirosLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var mediaLabel: UILabel!
    @IBOutlet weak var destLabel: UILabel!
    
}
    
class TableViewController: UITableViewController, WCSessionDelegate {

    var session : WCSession!
    
    let realm = try! Realm()
    let results = try! Realm().objects(ShotDB.self).sorted(byKeyPath: "fecha", ascending: false)
    
    
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Use the edit button item provided by the table view controller.
        
        //self.navigationItem.leftBarButtonItem = self.editButtonItem
        navigationItem.leftBarButtonItem = editButtonItem
        
        if WCSession.isSupported() {
            session = WCSession.default()
            session.delegate = self
            session.activate()
        }
        
        let realmFile = Realm.Configuration.defaultConfiguration.fileURL!
        
        print (realmFile)

        
        //print ("Realm file", myRealm.path)
        
        tableView.reloadData()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath) as! TableViewCell
        
        // Configure the cell...

        let item = results[indexPath.row]
        let fecha = decodeDate(Date())
        
        cell.fechaLabel?.text = fecha
        cell.distLabel?.text = "Dist.: " + item.dist
        cell.tirosLabel?.text = "Tiros: " + String(item.tiros)
        cell.totalLabel?.text = "Total: " + String(item.total)
        cell.mediaLabel?.text = "Media: " + String(item.media)
        cell.destLabel?.text = "Desv.T.: " + String(item.std)
        
        return cell
    }
    
    
    
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source

            try! realm.write {
                realm.delete(results[indexPath.row])
            
            }
            
            tableView.reloadData()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "DetailSegue" {
            let detailViewController = segue.destination as! DetailViewController
            let myIndexPath = self.tableView.indexPathForSelectedRow!
            let row = myIndexPath.row
            let myshot = results[row]
            detailViewController.myshot = myshot
            
           
        }
    }


    
    //MARK: WCSession Delegate
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        
        
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
        
        // Send a reply
        replyHandler(["Message":"Recibido"])
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





