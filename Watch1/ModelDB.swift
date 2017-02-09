//
//  ModelDB.swift
//  Watch1
//
//  Created by Ricardo Riosalido on 1/2/17.
//  Copyright © 2017 Ricardo Riosalido. All rights reserved.
//

import Foundation

import RealmSwift

class ShotDB : Object {
    
    dynamic var fecha = Date()
    dynamic var dist = ""
    dynamic var tiros = 0
    dynamic var total = 0
    dynamic var media = 0.0
    dynamic var std = 0.0
    dynamic var puntos = ""
    
}

/*
class Shot {
    
    private let value = [0,1,2,3,4,5,6,7,8,9,10,10]
    var fecha : Date
    var dist : String
    var table : [Int]
    var tiros : Int
    var total : Int
    var media : Double
    var std : Double
    private var sfx2 : Int
    
    init (fecha: Date, dist: String, table:[Int]) {
        self.fecha = fecha
        self.dist = dist
        self.table = table
        tiros = table.reduce(0, _:+)
        total = zip(table,value).map{$0 * $1}.reduce(0, _:+)
        media = Double(total)/Double(tiros)
        sfx2 = zip(table,value).map{$0 * $1 * $1}.reduce(0, _:+)
        std = sqrt(Double(sfx2) / Double(tiros) - (media * media))
        media = Double(round(10*media)/10)
        std = Double(round(10*std)/10)
    }
}


func shot2shotDB (_ mytirada: Shot) -> (ShotDB) {
    let mydata = ShotDB()
    mydata.fecha = Date()
    mydata.dist = mytirada.dist
    mydata.tiros = mytirada.tiros
    mydata.total = mytirada.total
    mydata.media = mytirada.media
    mydata.std = mytirada.std
    let arrayString = mytirada.table.map {String($0)}
    let string = arrayString.joined(separator: "-")
    mydata.puntos = string
    return mydata
}

func shotDB2shot (_ mytirada: ShotDB) -> (Shot) {
    //let mydata = Shot(fecha: mytirada.fecha, dist:mytirada.dist, table)
    let string = mytirada.puntos
    let arrayString = string.components(separatedBy: "-")
    let arrayInt = arrayString.map{Int($0)!}
    let mydata = Shot(fecha: mytirada.fecha, dist: mytirada.dist, table: arrayInt)
    return mydata
}

*/

func decodeDate(_ date: Date) -> (String){
    let year = String(Calendar.current.component(.year, from: date))
    let month = String(Calendar.current.component(.month, from: date))
    //let hour = String(Calendar.current.component(.hour, from: date))
    let day = String(Calendar.current.component(.day, from: date))
    var fecha = ""
    fecha = fecha + day + "-" + month + "-" + year  // + " " + hour
    return fecha
}

func statS (_ string:String) -> (tiros: Int, total: Int, media: Double, std:Double) {
    
    let arrayString = string.components(separatedBy: "-")
    let table = arrayString.map{Int($0)!}
    let value = [0,1,2,3,4,5,6,7,8,9,10,10]
    let tiros = table.reduce(0, _:+)
    let total = zip(table,value).map{$0 * $1}.reduce(0, _:+)
    var media = Double(total)/Double(tiros)
    let sfx2 = zip(table,value).map{$0 * $1 * $1}.reduce(0, _:+)
    var std = sqrt(Double(sfx2) / Double(tiros) - (media * media))
    media = Double(round(10*media)/10)
    std = Double(round(10*std)/10)
    return (tiros,total,media,std)
}
