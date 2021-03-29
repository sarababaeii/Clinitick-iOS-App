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
    @IBOutlet weak var dateTextField: CustomTextField!
    
    var patient: Patient?
    var clinic: Clinic?
    
    var textFieldDelegates = [TextFieldDelegate]()
    
    var appointment: Appointment?
    
    //MARK: Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    func configure() {
        Info.sharedInstance.isForReturn = true
        initializeTextFields()
        setDatePicker(dateTextFieldIndex: 2, mode: .dateAndTime)
        setTitle(title: "فعالیت درمانی")
    }
    
    func initializeTextFields() {
        textFields = [diseaseTextField, priceTextField, dateTextField]
        data = ["", -1] //0: disease, 1: price
        setTextFieldDelegates()
        setTextFieldsData()
    }
    
    func setTextFieldsData() {
        if let appointment = appointment {
            diseaseTextField.text = appointment.disease
            if appointment.price != -1 {
                priceTextField.text = String.toEnglishPriceString(price: Int(truncating: appointment.price))
            }
            if appointment.visit_time != Date.defaultDate() {
                dateTextField.text = appointment.visit_time.toCompletePersianString()
            }
            data = [appointment.disease, Int(truncating: appointment.price)]
            super.date = appointment.visit_time
            self.patient = appointment.patient
            self.clinic = appointment.clinic
        }
    }
    
    func setTextFieldDelegates() {
        textFieldDelegates = [
            TextFieldDelegate(viewController: self, isForPrice: false, isForDate: false),
            TextFieldDelegate(viewController: self, isForPrice: true, isForDate: false),
            TextFieldDelegate(viewController: self, isForPrice: false, isForDate: true)]
        for i in 0 ..< 3 {
            textFields[i].delegate = textFieldDelegates[i]
        }
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
        let appointment = Appointment.createAppointment(id: self.appointment?.id, patient: patient!, clinic: clinic!, disease: data[0] as! String, price: data[1] as? Int, date: date, state: self.appointment?.state ?? TaskState.todo.rawValue, isDeleted: nil, modifiedTime: Date())
        print(appointment)
        Info.sharedInstance.sync()
    }
    
    override func back() {
        navigateToPage(identifier: "TabBarViewController")
    }
}
