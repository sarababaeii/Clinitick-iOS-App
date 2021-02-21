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
    @IBOutlet weak var priceTetField: CustomTextField!
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
        textFields = [diseaseTextField, priceTetField, dateTextField]
        data = ["", -1] //0: disease, 1: price
        setTextFieldDelegates()
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
    
    @IBAction func submit(_ sender: Any) {
        submitForm()
    }
    
    override func mustComplete() -> Any? {
        if data[0] as! String == "" {
            return textFields[0]
        }
        if data[1] as! Int == -1 {
            return textFields[1]
        }
        if date == nil {
            return textFields[2]
        }
        return nil
    }
    
    override func saveData() {
        let appointment = Appointment.createAppointment(id: nil, patient: patient!, clinic: clinic!, diseaseTitle: data[0] as! String, price: data[1] as! Int, date: date!)
        print(appointment)
        RestAPIManagr.sharedInstance.addAppointment(appointment: appointment)
    }
    
    override func back() {
        navigateToPage(identifier: "TabBarViewController")
    }
}
