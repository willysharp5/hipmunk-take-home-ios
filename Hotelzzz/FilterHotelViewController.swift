//
//  FilterHotelViewController.swift
//  Hotelzzz
//
//  Created by Edo williams on 4/6/18.
//  Copyright © 2018 Hipmunk, Inc. All rights reserved.
//

import UIKit

protocol FilterHotelViewControllerDelegate: class {
    func filterOption(priceMax: String, priceMin: String, setFilter: Bool)
}


class FilterHotelViewController: UIViewController {

    weak var delegate: FilterHotelViewControllerDelegate?
    
    @IBOutlet weak var startRange: UITextField!
    @IBOutlet weak var endRange: UITextField!
    
    var priceMax = ""
    var priceMin = ""
    var setFilter = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        priceMax = priceMax.replacingOccurrences(of: "\u{22}", with: "")
        startRange.text = priceMax
        priceMin = priceMin.replacingOccurrences(of: "\u{22}", with: "")
        endRange.text = priceMin
    }
    


    @IBAction func doneDidTouch(_ sender: Any) {
        priceMax = startRange.text!
        priceMin = endRange.text!
        setFilter = true
        self.delegate?.filterOption(priceMax: priceMax, priceMin: priceMin, setFilter: setFilter)
        self.dismiss(animated: true, completion: nil)
    }
    
}


