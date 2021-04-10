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
    @IBOutlet weak var dateTextField: CustomTextField!
    
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
    
    var data = ["", -1] as [Any] //0: disease, 1: price
    var date: Date?
    var isFilled = false
    
    
    func setAttributes(viewController: AddAppointmentViewController) {
        self.viewController = viewController
        initializeTextFields()
        setDatePicker(dateTextFieldIndex: 2, mode: .dateAndTime)
    }
    
    func initializeTextFields() {
        textFields = [diseaseTextField, priceTextField, dateTextField]
        data = ["", -1] //0: disease, 1: price
        setTextFieldDelegates()
//        setTextFieldsData()
    }
    
    func setTextFieldDelegates() {
        textFieldDelegates = [
            TextFieldDelegate(tableViewCell: self, isForPrice: false, isForDate: false, isForAppointmetTitle: true),
            TextFieldDelegate(tableViewCell: self, isForPrice: true, isForDate: false, isForAppointmetTitle: false),
            TextFieldDelegate(tableViewCell: self, isForPrice: false, isForDate: true, isForAppointmetTitle: false)]
        for i in 0 ..< 3 {
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
        let appointment = Appointment.createAppointment(id: nil, patient: viewController.patient!, clinic: viewController.clinic!, disease: data[0] as! String, price: data[1] as? Int, date: date, state: TaskState.todo.rawValue, isDeleted: nil, modifiedTime: Date())
        print(appointment)
//        Info.sharedInstance.sync() //TODO: yes?
    }
}
