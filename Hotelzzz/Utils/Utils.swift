//
//  Utils.swift
//  Hotelzzz
//
//  Created by Edo williams on 4/5/18.
//  Copyright © 2018 Hipmunk, Inc. All rights reserved.
//

import UIKit

struct Utils {
    static func cleanUpData(dic: NSDictionary) -> hotelInfo {
        //flatten data to an array and split by semi column
        let stringData = (dic.flatMap({ (key, value) -> String in
            return "\(value)"
        }) as Array).joined(separator: ";")
        
        //split data by equal sign into an array
        let anotherComponent = stringData.components(separatedBy: "=") as Array
        /*print("address: \(anotherComponent[2])") //address
         print("imageURL: \(anotherComponent[4])") //imageURL
         print("name: \(anotherComponent[5])") //name
         print("price: \(anotherComponent[6])") //price*/
        
        //extract the data from teh array location and split by semi column again
        let addressToSplit = anotherComponent[2]
        let address = addressToSplit.components(separatedBy: ";")
        
        let imageURLToSplit = anotherComponent[4]
        let imageURL = imageURLToSplit.components(separatedBy: ";")
        
        let nameToSplit = anotherComponent[5]
        let name = nameToSplit.components(separatedBy: ";")
        
        let priceToSplit = anotherComponent[6]
        let price = priceToSplit.components(separatedBy: ";")
        
        
        /*print(address[0])
         print(imageURL[0])
         print(name[0])
         print(price[0])*/
        
        
        let hotelData = hotelInfo()
        hotelData.address = (address[0].replacingOccurrences(of: "\"", with: "")).replacingOccurrences(of: "\\n", with: " ") //remove double quotes
        hotelData.imageURL = imageURL[0].replacingOccurrences(of: "\"", with: "") 
        hotelData.name = name[0].replacingOccurrences(of: "\"", with: "")
        hotelData.price = price[0]
        
        return hotelData
    }
}
