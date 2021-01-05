//
//  FormViewController.swift
//  Brandent
//
//  Created by Sara Babaei on 12/16/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//

import Foundation
import UIKit
import SwiftyMenu

class FormViewController: NavigationBarViewController {
    
    var textFields: [CustomTextField] = []
    var currentTextField: UITextField?
    
    var datePicker: UIDatePicker?
    var dateTextFieldIndex: Int?
    
    var data: [Any] = []
    var date: Date?
    
    //MARK: Date Picker Functions
    func setDatePicker(dateTextFieldIndex: Int, mode: UIDatePicker.Mode) {
        initializeDatePicker(mode: mode)
        initializeDateTextField(dateTextFieldIndex: dateTextFieldIndex)
        setDoneButton()
    }
    
    private func initializeDatePicker(mode: UIDatePicker.Mode) {
        datePicker = UIDatePicker()
        datePicker!.createPersianDatePicker(mode: mode)
    }
    
    private func initializeDateTextField(dateTextFieldIndex: Int) {
        self.dateTextFieldIndex = dateTextFieldIndex
        textFields[dateTextFieldIndex].inputView = datePicker
    }
    
    private func setDoneButton() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([doneButton], animated: true )
        
        if let index = dateTextFieldIndex {
            textFields[index].inputAccessoryView = toolbar
        }
    }
    
    @objc func donePressed() {
        guard let index = dateTextFieldIndex, let picker = datePicker else {
            return
        }
        textFields[index].text = picker.date.toPersianDMonthYString()
        textFields[index].endEditing(true)
        date = picker.date
    }
    
    //MARK: Submission
    func submitForm() {
        getLastData()
        if let requiredItem = mustComplete() {
            print(requiredItem)
            submitionError(for: requiredItem)
            return
        }
        saveData()
        back()
    }
    
    func getLastData() {
        guard let textField = currentTextField else {
            return
        }
        textField.delegate?.textFieldDidEndEditing?(textField)
        currentTextField = nil
    }
    
    func mustComplete() -> Any? { //will be overriden in child classes
        return nil
    }
    
    func submitionError(for requiredItem: Any) {
        if let textField = requiredItem as? CustomTextField {
            textField.showError()
        }
        else if let menu = requiredItem as? SwiftyMenu {
            menu.showError()
        }
        self.showToast(message: "خطا: همه‌ی موارد ضروری وارد نشده است.")
    }
    
    func saveData() { //will be overriden in child classes
    }
    
    func back() {
        self.navigationController?.popViewController(animated: true)
    }
}
