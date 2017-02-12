//
//  TableTableViewController.swift
//  Watch1
//
//  Created by Ricardo Riosalido on 26/1/17.
//  Copyright © 2017 Ricardo Riosalido. All rights reserved.
//

import UIKit
import RealmSwift
import MessageUI

class TableViewCell : UITableViewCell{
    
    
    @IBOutlet weak var fechaLabel: UILabel!
    @IBOutlet weak var distLabel: UILabel!
    @IBOutlet weak var tirosLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var mediaLabel: UILabel!
    @IBOutlet weak var destLabel: UILabel!
    
}
    
class TableViewController: UITableViewController, MFMailComposeViewControllerDelegate {


    
    let realm = try! Realm()
    let results = try! Realm().objects(ShotDB.self).sorted(byKeyPath: "fecha", ascending: false)
    
    var fileURL : URL!
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Use the edit button item provided by the table view controller.
        
        //self.navigationItem.leftBarButtonItem = self.editButtonItem
        navigationItem.leftBarButtonItem = editButtonItem
        
        
        let realmFile = Realm.Configuration.defaultConfiguration.fileURL!
        
        print (realmFile)

        
        //print ("Realm file", myRealm.path)
        
        tableView.reloadData()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    }

    override func viewWillAppear(_ animated: Bool) {
         tableView.reloadData()
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
    
    
    @IBAction func exportCSV(_ sender: UIBarButtonItem) {
        
        export()
        sendMail()
    }
    

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

    
    
    func export () {
        print ("Export")
        // Preparacion para exportar a CSV
        
        var csv = "Fecha,Dist,Tiros,Total,Media,Std,M,P1,P2,P3,P4,P5,P6,P7,P8,P9,P10,X\n"
        for i in 1..<self.results.count {
            print (i)
            let reg = results[i]
            let fecha = decodeDate(reg.fecha)
            csv.append(fecha + ",")
            csv.append(reg.dist + ",")
            csv.append(String(reg.tiros)+",")
            csv.append(String(reg.total)+",")
            csv.append(String(reg.media)+",")
            csv.append(String(reg.std)+",")
            csv.append(reg.puntos+"\n")
        }
        print (csv)
        
        // Save data to file
        let fileName = "Tiradas"
        let DocumentDirURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        
        fileURL = DocumentDirURL.appendingPathComponent(fileName).appendingPathExtension("csv")
        print("FilePath: \(fileURL.path)")
        do {
            // Write to the file
            try csv.write(to: fileURL, atomically: true, encoding: String.Encoding.utf8)
        } catch let error as NSError {
            print("Failed writing to URL: \(fileURL), Error: " + error.localizedDescription)
        }
    }
    
    
    
    func sendMail(){
        
        if !MFMailComposeViewController.canSendMail() {
            print("Mail services are not available")
            //sendMailButton.isEnabled = false
            // deshabilitar boton send mail
            return
            
        } else {
            
            let composeVC = MFMailComposeViewController()
            composeVC.mailComposeDelegate = self
            
            // Configure the fields of the interface.
            composeVC.setToRecipients(["rriosalido@icloud.com"])
            composeVC.setSubject("Fichero Tiradas")
            composeVC.setMessageBody("Fichero CSV de Tiradas", isHTML: false)
            
            let filePath = self.fileURL.path
            
            if let fileData = NSData(contentsOfFile: filePath) {
                print("File data loaded.")
                composeVC.addAttachmentData(fileData as Data, mimeType: "test/csv", fileName: "Tiradas.csv")
                
            }
            /*
            if let filePath = Bundle.main.path(forResource: "Tiradas", ofType: "csv") {
                print("File path loaded: ",filePath)
                if let fileData = NSData(contentsOfFile: filePath) {
                    print("File data loaded.")
                    composeVC.addAttachmentData(fileData as Data, mimeType: "test/csv", fileName: "Tiradas")
                    
                }
             }
            */
            
                // Present the view controller modally.
                self.present(composeVC, animated: true, completion: nil)
            }
        }
    
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}





