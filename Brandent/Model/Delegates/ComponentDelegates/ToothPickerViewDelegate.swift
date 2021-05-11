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
    
    var pickerView: UIPickerView
    var textField: UITextField
    var clearButton: UIButton
    
    var numberOfComponents = 2
    let options1 = ["Upper Left", "Upper Right", "Lower Left", "Lower Right"]
    let options2 = ["1", "2", "3", "4", "5", "6", "7", "8"]
    let options3 = ["A", "B", "C", "D", "E"]
    
    var isChild = false
    var selectedRow = [0, 0]
    
    //MARK: Initialization
    init(pickerView: UIPickerView, textField: UITextField, clearButton: UIButton) {
        self.pickerView = pickerView
        self.textField = textField
        self.clearButton = clearButton
        textField.inputView = pickerView
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
            return row < options1.count ? options1[row] : ""
        case 1:
            return isChild ? (row < options3.count ? options3[row] : "") : (row < options2.count ? options2[row] : "")
        default:
            return row < options1.count ? options1[row] : ""
        }
    }
    
    //MARK: Selecting an Option
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedRow[component] = row
        setTextFieldText()
    }
    
    func setTextFieldText() {
        let txt = "\(options1[selectedRow[0]]) \(getSecondOptionText(index: selectedRow[1]))"
        textField.text = txt
        clearButton.isHidden = false
    }
    
    private func getSecondOptionText(index: Int) -> String {
        if isChild {
            return index < options3.count ? options3[index] : ""
        }
        return index < options2.count ? options2[index] : ""
    }
    
    //MARK: Child or Adult
    func isChildPressed(button: Any?) {
        isChild = !isChild
        changeIsChildTitle(button: button)
        reloadComponent(1)
    }
    
    private func changeIsChildTitle(button: Any?) {
        guard let button = button as? UIBarButtonItem else {
            return
        }
        if isChild {
            button.title = "Adult"
        } else {
            button.title = "Child"
        }
    }
    
    private func reloadComponent(_ component: Int) {
        pickerView.reloadComponent(component)
        setTextFieldText()
    }
    
    //MARK: Saving Option
    func getSelectedOptionTextForDB() -> String {
        return "\(options1[selectedRow[0]]) \(getSecondOptionText(index: selectedRow[1]))"
    }
}

//TODO: if from adult changed to child
