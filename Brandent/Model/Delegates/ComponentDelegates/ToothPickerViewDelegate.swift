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
    let options3 = ["A", "B", "C", "D", "E", "F"]
    
    var isAdult = true
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
            return isAdult ? options2.count : options3.count
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
            return isAdult ? options2[row] : options3[row]
        default:
            return options1[row]
        }
    }
    
    //MARK: Selecting an Option
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedRow[component] = row
        setTextFieldText()
    }
    
    private func setTextFieldText() {
        let txt = "\(getFirstOptionText(isForDB: false, index: selectedRow[0])) \(getSecondOptionText(index: selectedRow[1]))"
        textField.text = txt
    }
    
    private func getFirstOptionText(isForDB: Bool, index: Int) -> String {
        switch options1[index] {
        case "UL":
            return isForDB ? "UpperLeft" : "Upper Left"
        case "UR":
            return isForDB ? "UpperRight" : "Upper Right"
        case "LL":
            return isForDB ? "LowerLeft" : "Lower Left"
        case "LR":
            return isForDB ? "LowerRight" : "Lower Right"
        default:
            return isForDB ? "UpperLeft" : "Upper Left"
        }
    }
    
    private func getSecondOptionText(index: Int) -> String {
        if isAdult {
            return options2[index]
        }
        return options3[index]
    }
    
    func getSelectedOptionTextForDB() -> String {
        return "\(getFirstOptionText(isForDB: true, index: selectedRow[0])) \(getSecondOptionText(index: selectedRow[1]))"
    }
}
