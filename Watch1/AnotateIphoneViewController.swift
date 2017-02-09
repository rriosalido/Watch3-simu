//  AnotateIphoneViewController.swift
//  Watch1
//
//  Created by Ricardo Riosalido on 6/2/17.
//  Copyright © 2017 Ricardo Riosalido. All rights reserved.
//

import UIKit

class AnotateIphoneViewController: UIViewController {
    
    
    //MARK: Variables
    
    var maxRondas = 3
    var maxFlechas = 6
    var numShots = 0
    var ronda = 1
    var puntosTirada = [String]()
    var tiradas = [[String]()]
    var labelScore = " "
    var distancia = 15
    var config = [Int]()
    
    // MARK: Outlets
    
    
    @IBOutlet weak var numRonda: UILabel!
    @IBOutlet weak var parcialScore: UILabel!
    
    
    @IBOutlet weak var buttonX: UIButton!
    @IBOutlet weak var button10: UIButton!
    @IBOutlet weak var button9: UIButton!
    @IBOutlet weak var button8: UIButton!
    @IBOutlet weak var button7: UIButton!
    @IBOutlet weak var button6: UIButton!
    @IBOutlet weak var button5: UIButton!
    @IBOutlet weak var button4: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var buttonM: UIButton!
    
    @IBOutlet weak var endButton: UIButton!
    @IBOutlet weak var clearLast: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nextButton.isEnabled = false
        nextButton.alpha = 0.5
        endButton.isEnabled = false
        endButton.alpha = 0.5
        numRonda.text = "Ronda Nº 1 de " + String(maxRondas)
        parcialScore.text = labelScore
        clearLast.isEnabled = false
        clearLast.alpha = 0.5
        
        /*
         config = context as! [Int]
         self.maxRondas = config[0]
         self.maxFlechas = config[1]
         self.distancia = config[2]
         */
        tiradas[0]=[String(distancia)+"m"]
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
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
            nextButton.isEnabled = false
            //   WKInterfaceController.reloadRootControllers(withNames: ["ResultsController"], contexts: [tiradas])
            
        } else {
            numRonda.text = "Ronda Nº " + String(ronda) + " de " + String(maxRondas)
            nextButton.isEnabled = false
            nextButton.alpha = 0.5
            endButton.isEnabled = false
            endButton.alpha = 0.5
            enableButtons()
            numShots = 0
            puntosTirada = []
            labelScore = " "
            parcialScore.text = labelScore
        }
    }
    
    func numberPressed (_ value : String){
        
        numShots += 1
        puntosTirada.append(value)
        labelScore = listaRonda(puntosTirada)
        print (labelScore)
        parcialScore.text = labelScore
        clearLast.isEnabled = true
        clearLast.alpha = 1.0
        if numShots == maxFlechas {
            disableButtons()
            tiradas.append(puntosTirada)
            print (tiradas)
            let suma = sumaRonda(puntosTirada)
            labelScore.remove(at: labelScore.index (before: labelScore.endIndex))
            labelScore = labelScore + "=" + String(suma)
            parcialScore.text = labelScore
            if ronda == maxRondas {
                nextButton.isEnabled = false
                nextButton.alpha = 0.5
            } else {
                nextButton.isEnabled = true
                nextButton.alpha = 1.0
            }
            endButton.isEnabled = true
            endButton.alpha = 1.0
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
            clearLast.isEnabled = false
            clearLast.alpha = 0.5
        }
        parcialScore.text = labelScore
        enableButtons()
        endButton.isEnabled = false
        endButton.alpha = 0.5
        nextButton.isEnabled = false
        nextButton.alpha = 0.5
        
    }
    
    
    
    @IBAction func endTirada() {
        // no se llega al maximo de tiradas, pero se finaliza
        // pasa directamente a resultados
        ronda = maxRondas
        nextRonda()
    }
    
    func disableButtons (){
        button1.isEnabled = false
        button1.alpha = 0.5
        button2.isEnabled = false
        button2.alpha = 0.5
        button3.isEnabled = false
        button3.alpha = 0.5
        button4.isEnabled = false
        button4.alpha = 0.5
        button5.isEnabled = false
        button5.alpha = 0.5
        button6.isEnabled = false
        button6.alpha = 0.5
        button7.isEnabled = false
        button7.alpha = 0.5
        button8.isEnabled = false
        button8.alpha = 0.5
        button9.isEnabled = false
        button9.alpha = 0.5
        button10.isEnabled = false
        button10.alpha = 0.5
        buttonM.isEnabled = false
        buttonM.alpha = 0.5
        buttonX.isEnabled = false
        buttonX.alpha = 0.5
    }
    
    func enableButtons(){
        button1.isEnabled = true
        button1.alpha = 1.0
        button2.isEnabled = true
        button2.alpha = 1.0
        button3.isEnabled = true
        button3.alpha = 1.0
        button4.isEnabled = true
        button4.alpha = 1.0
        button5.isEnabled = true
        button5.alpha = 1.0
        button6.isEnabled = true
        button6.alpha = 1.0
        button7.isEnabled = true
        button7.alpha = 1.0
        button8.isEnabled = true
        button8.alpha = 1.0
        button9.isEnabled = true
        button9.alpha = 1.0
        button10.isEnabled = true
        button10.alpha = 1.0
        buttonM.isEnabled = true
        buttonM.alpha = 1.0
        buttonX.isEnabled = true
        buttonX.alpha = 1.0
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
