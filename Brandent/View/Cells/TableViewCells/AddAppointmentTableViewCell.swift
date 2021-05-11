//
//  AddAppointmentTableViewCell.swift
//  Brandent
//
//  Created by Sara Babaei on 3/22/21.
//  Copyright © 2021 Sara Babaei. All rights reserved.
//

import Foundation
import UIKit

class AddAppointmentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var diseaseTextField: CustomTextField!
    @IBOutlet weak var priceTextField: CustomTextField!
    @IBOutlet weak var toothTextField: CustomTextField!
    @IBOutlet weak var dateTextField: CustomTextField!
    @IBOutlet weak var clearToothButton: UIButton!
    @IBOutlet weak var clearDateButton: UIButton!
    
    var viewController: AddAppointmentViewController?
    
    var textFieldDelegates = [TextFieldDelegate]()
    var textFields = [CustomTextField]()
    var currentTextField: UITextField? {
        didSet {
            viewController?.currentCell = self
        }
    }
    
    var datePicker: UIDatePicker?
    var dateTextFieldIndex: Int?
    
    var toothPicker: UIPickerView?
    var toothPickerDelegate: ToothPickerViewDelegate?
    var toothTextFieldIndex: Int?
    
    var data = ["", -1, ""] as [Any] //0: disease, 1: price, 2: tooth
    var date: Date?
    var isFilled = false
    
    func setAttributes(viewController: AddAppointmentViewController) {
        self.viewController = viewController
        initializeTextFields()
        setToothPicker(toothTextFieldIndex: 2)
        setDatePicker(dateTextFieldIndex: 3, mode: .dateAndTime)
    }
    
    func initializeTextFields() {
        textFields = [diseaseTextField, priceTextField, toothTextField, dateTextField]
        data = ["", -1, ""] //0: disease, 1: price, 2: tooth
        setTextFieldDelegates()
//        setTextFieldsData()
    }
    
    func setTextFieldDelegates() {
        textFieldDelegates = [
            AppointmentTitleTextFieldDelegate(tableViewCell: self),
            PriceTextFieldDelegate(viewController: self),
            ToothTextFieldDelegate(viewController: self),
            DateTextFieldDelegate(viewController: self)]
        for i in 0 ..< 4 {
            textFields[i].delegate = textFieldDelegates[i]
        }
    }
    
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
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector (donePressed))
        doneButton.target = self
        toolbar.setItems([doneButton], animated: true )
        if let index = dateTextFieldIndex {
            textFields[index].inputAccessoryView = toolbar
        }
    }
    
    @objc func donePressed() {
        guard let index = dateTextFieldIndex, let picker = datePicker else {
            return
        }
        if isFilled {
            textFields[index].text = picker.date.toCompletePersianString()
            date = picker.date
        }
        textFields[index].endEditing(true)
        clearDateButton.isHidden = false
    }
    
    @IBAction func clearDate(_ sender: Any) {
        guard let button = sender as? UIButton else {
            return
        }
        date = nil
        textFields[button.tag].text = ""
        clearDateButton.isHidden = true
    }
    
    //MARK: Tooth Picker Functions
    func setToothPicker(toothTextFieldIndex: Int) {
        self.toothTextFieldIndex = toothTextFieldIndex
        initializeToothPicker()
        setToothPickerButtons()
    }
    
    private func initializeToothPicker() {
        toothPicker = UIPickerView()
        toothPickerDelegate = ToothPickerViewDelegate(pickerView: toothPicker!, textField: toothTextField, clearButton: clearToothButton)
        toothPicker?.delegate = toothPickerDelegate
        toothPicker?.dataSource = toothPickerDelegate
    }
    
    private func setToothPickerButtons() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector (doneForToothPressed))
        let isChildButton = UIBarButtonItem(title: "Child", style: .plain, target: self, action: #selector (isChildPressed))
        toolbar.setItems([doneButton, isChildButton], animated: true )
        if let index = toothTextFieldIndex {
            textFields[index].inputAccessoryView = toolbar
        }
    }
    
    @objc func doneForToothPressed() {
        guard let index = toothTextFieldIndex, let pickerDelegate = toothPickerDelegate else {
            return
        }
        if isFilled {
            data[index] = pickerDelegate.getSelectedOptionTextForDB()
            pickerDelegate.setTextFieldText()
        }
        textFields[index].endEditing(true)
    }
    
    @objc func isChildPressed(_ sender: Any?) {
        guard let pickerDelegate = toothPickerDelegate else {
            return
        }
        pickerDelegate.isChildPressed(button: sender)
    }
    
    @IBAction func clearTooth(_ sender: Any) {
        guard let button = sender as? UIButton else {
            return
        }
        data[button.tag] = ""
        textFields[button.tag].text = ""
        clearToothButton.isHidden = true
    }
    
    //MARK: Submission
    func submit() -> Bool {
        getLastData()
        if !isFilled {
            return false
        }
        saveData()
        return true
    }
    
    func getLastData() {
        guard let textField = currentTextField else {
            return
        }
        if textField.tag == dateTextFieldIndex {
            donePressed()
        }
        textField.delegate?.textFieldDidEndEditing?(textField)
        currentTextField = nil
    }
    
    func mustComplete() -> Any? {
        if data[0] as! String == "" {
            return textFields[0]
        }
        return nil
    }
    
    func saveData() {
        guard let viewController = viewController else {
            return
        }
        let appointment = Appointment.createAppointment(id: nil, patient: viewController.patient!, clinic: viewController.clinic!, disease: data[0] as! String, price: data[1] as? Int, date: date, tooth: data[2] as! String, state: TaskState.todo.rawValue, isDeleted: nil, modifiedTime: Date())
        print(appointment)
        print("ONE APPOINTMENT SAVED")
    }
}
