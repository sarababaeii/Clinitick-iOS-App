//
//  PickerViewDelegate.swift
//  Brandent
//
//  Created by Sara Babaei on 11/4/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//

import Foundation
import UIKit

class PickerViewDelegate: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var options = ["درآمد", "هزینه"]
    var textField: UITextField
    var selectedRow = 0
    
    init(textField: UITextField) {
        self.textField = textField
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return options.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel?// = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont(name: "Vazir", size: 20)
            pickerLabel?.textAlignment = .center
        }
        pickerLabel?.text = options[row]
        return pickerLabel!
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        textField.text = options[row]
        selectedRow = row
    }
}
