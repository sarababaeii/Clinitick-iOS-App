//
//  PickerViewDelegate.swift
//  Brandent
//
//  Created by Sara Babaei on 11/4/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//

import Foundation
import UIKit

class ToothPickerViewDelegate: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var textField: UITextField
    var numberOfComponents = 2
    let options1 = ["UL", "UR", "LL", "LR"]
    let options2 = ["1", "2", "3", "4", "5", "6", "7", "8"]
    let options3 = ["A", "B", "C", "D", "E"]
    
    var isChild = false
    var selectedRow = [0, 0]
    
    //MARK: Initialization
    init(textField: UITextField) {
        self.textField = textField
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return numberOfComponents
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return options1.count
        case 1:
            return isChild ? options3.count : options2.count
        default:
            return options1.count
        }
    }
    
    //MARK: Setting Options
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel?// = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont(name: "Vazir", size: 20)
            pickerLabel?.textAlignment = .center
        }
        pickerLabel?.text = getOption(component: component, row: row)
        return pickerLabel!
    }
    
    private func getOption(component: Int, row: Int) -> String {
        switch component {
        case 0:
            return options1[row]
        case 1:
            return isChild ? options3[row] : options2[row]
        default:
            return options1[row]
        }
    }
    
    //MARK: Selecting an Option
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedRow[component] = row
        setTextFieldText()
    }
    
    func setTextFieldText() {
        let txt = "\(getFirstOptionText(index: selectedRow[0])) \(getSecondOptionText(index: selectedRow[1]))"
        textField.text = txt
    }
    
    private func getFirstOptionText(index: Int) -> String {
        switch options1[index] {
        case "UL":
            return "Upper Left"
        case "UR":
            return "Upper Right"
        case "LL":
            return "Lower Left"
        case "LR":
            return "Lower Right"
        default:
            return "Upper Left"
        }
    }
    
    private func getSecondOptionText(index: Int) -> String {
        if isChild {
            return options3[index]
        }
        return options2[index]
    }
    
    func getSelectedOptionTextForDB() -> String {
        return "\(options1[selectedRow[0]])\(getSecondOptionText(index: selectedRow[1]))"
    }
}
