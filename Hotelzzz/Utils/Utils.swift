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
        let stringData = (dic.flatMap({ (key, value) -> String in
            return "\(value)"
        }) as Array).joined(separator: ";")
        
        let anotherComponent = stringData.components(separatedBy: "=") as Array
        /*print("address: \(anotherComponent[2])") //address
         print("imageURL: \(anotherComponent[4])") //imageURL
         print("name: \(anotherComponent[5])") //name
         print("price: \(anotherComponent[6])") //price*/
        
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
        hotelData.address = address[0]
        hotelData.imageURL = imageURL[0]
        hotelData.name = name[0]
        hotelData.price = price[0]
        
        return hotelData
    }
}
