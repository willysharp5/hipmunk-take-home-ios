//
//  SortHotelViewController.swift
//  Hotelzzz
//
//  Created by Edo williams on 4/6/18.
//  Copyright © 2018 Hipmunk, Inc. All rights reserved.
//

import UIKit


protocol SortHotelViewControllerDelegate: class {
    func sortOption(sortOption: String)
}


class SortHotelViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    weak var delegate: SortHotelViewControllerDelegate?
    var selectedOption = "name"
    let pickerViewData = ["name","priceAscend","priceDescend"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pickerView.dataSource = self
        self.pickerView.delegate = self
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerViewData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerViewData[row]
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedOption = pickerViewData[row]
    }
    
    
    @IBAction func didTouchDone(_ sender: Any) {
        //print(selectedOption)
        self.delegate?.sortOption(sortOption: selectedOption)
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
