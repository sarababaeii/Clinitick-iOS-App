//
//  TempAddAppointmentViewController.swift
//  Brandent
//
//  Created by Sara Babaei on 12/28/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//

import Foundation
import UIKit

class TempAddAppointmrntViewController: FormViewController {
    
    @IBOutlet weak var diseaseTextField: CustomTextField!
    @IBOutlet weak var priceTextField: CustomTextField!
    @IBOutlet weak var toothTextField: CustomTextField!
    @IBOutlet weak var dateTextField: CustomTextField!
    @IBOutlet weak var clearToothButton: UIButton!
    @IBOutlet weak var clearDateButton: UIButton!
    
    var patient: Patient?
    var clinic: Clinic?
    
    var textFieldDelegates = [TextFieldDelegate]()
    
    var toothPicker: UIPickerView?
    var toothPickerDelegate: ToothPickerViewDelegate?
    var toothTextFieldIndex: Int?
    
    var appointment: Appointment?
    
    //MARK: Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    func configure() {
        Info.sharedInstance.isForReturn = true
        initializeTextFields()
        setToothPicker(toothTextFieldIndex: 2)
        setDatePicker(dateTextFieldIndex: 3, mode: .dateAndTime)
        setTitle(title: "فعالیت درمانی")
    }
    
    func initializeTextFields() {
        textFields = [diseaseTextField, priceTextField, toothTextField, dateTextField]
        data = ["", -1, ""] //0: disease, 1: price, 2: tooth
        setTextFieldDelegates()
        setTextFieldsData()
    }
    
    func setTextFieldsData() {
        guard let appointment = appointment else {
            return
        }
        diseaseTextField.text = appointment.disease
        if appointment.price != -1 {
            priceTextField.text = String.toEnglishPriceString(price: Int(truncating: appointment.price))
        }
        if appointment.visit_time != Date.defaultDate() {
            dateTextField.text = appointment.visit_time.toCompletePersianString()
            clearDateButton.isHidden = false
        }
        if appointment.tooth != "" {
            toothTextField.text = appointment.tooth
            clearToothButton.isHidden = false
        }
        data = [appointment.disease, Int(truncating: appointment.price), appointment.tooth]
        super.date = appointment.visit_time
        self.patient = appointment.patient
        self.clinic = appointment.clinic
    }
    
    func setTextFieldDelegates() {
        textFieldDelegates = [
            TextFieldDelegate(viewController: self),
            PriceTextFieldDelegate(viewController: self),
            ToothTextFieldDelegate(viewController: self),
            DateTextFieldDelegate(viewController: self)]
        for i in 0 ..< 4 {
            textFields[i].delegate = textFieldDelegates[i]
        }
    }
    
    //MARK: Date Picker Functions
    override func donePressed() {
        super.donePressed()
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
        data[index] = pickerDelegate.getSelectedOptionTextForDB()
        pickerDelegate.setTextFieldText()
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
    
    //MARK: Keyboard Management
    @IBAction func hideKeyboard(_ sender: Any) {
        if let textField = currentTextField {
            textField.resignFirstResponder()
        }
    }
    
    //MARK: Submission
    @IBAction func submit(_ sender: Any) {
        submitForm()
    }
    
    override func mustComplete() -> Any? {
        if data[0] as! String == "" {
            return textFields[0]
        }
        return nil
    }
    
    override func saveData() {
        let appointment = Appointment.createAppointment(id: self.appointment?.id, patient: patient!, clinic: clinic!, disease: data[0] as! String, price: data[1] as? Int, date: date, tooth: data[2] as! String, state: self.appointment?.state ?? TaskState.todo.rawValue, isDeleted: nil, modifiedTime: Date())
        print(appointment)
        Info.sharedInstance.sync()
    }
    
    override func back() {
        navigateToPage(identifier: "TabBarViewController")
    }
}
