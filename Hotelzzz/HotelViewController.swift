//
//  HotelViewController.swift
//  Hotelzzz
//
//  Created by Steve Johnson on 3/22/17.
//  Copyright © 2017 Hipmunk, Inc. All rights reserved.
//

import Foundation
import UIKit


class HotelViewController: UIViewController {
    var hotelData = hotelInfo()
    
    @IBOutlet var hotelNameLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hotelNameLabel.text = hotelData.name
        print(hotelData.imageURL)
        addressLabel.text = hotelData.address
        priceLabel.text = hotelData.price
        
    }
}
