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


func listaRonda (_ array : [String]) -> String {
    var lista = String()
    for val in array {
        lista.append(val)
        lista.append("-")
    }
    return lista
}

func punt2int (_ value: String) -> Int{
    var score = 0
    if value == "X" {
        score = 10
    } else if value == "M" {
        score = 0
    } else {
        score = Int(value)!
    }
    return score
}

func sumaRonda (_ array: [String]) -> Int {
    var suma = 0
    for i in array {
        suma = suma + punt2int(i)
    }
    return suma
}

func tablaFreq (_ array:[[String]]) -> [Int]{
    var tabla = [Int](repeating: 0, count: 12)
    var point : String
    for i in 1..<array.count {
        for j in 0..<array[i].count {
            point = array[i][j]
            switch point {
            case "M":
                tabla[0] += 1
            case "X":
                tabla[11] += 1
            default:
                tabla[punt2int(point)] += 1
            }
        }
    }
    return tabla
}
