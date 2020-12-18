//
//  AddTask.swift
//  Brandent
//
//  Created by Sara Babaei on 12/13/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//

import Foundation
import UIKit
import SwiftyMenu

class AddTaskViewController: FormViewController, SwiftyMenuDelegate {
    
    @IBOutlet weak var titleTextField: CustomTextField!
    @IBOutlet weak var dateTextField: CustomTextField!
    @IBOutlet weak var clinicMenu: SwiftyMenu!
    
    var textFieldDelegates = [TextFieldDelegate]()
    var clinicOptions = [String]()
    
    //MARK: Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    func configure() {
        initializeTextFields()
        prepareClinicMenu()
        setDatePicker(dateTextFieldIndex: 1, mode: .date)
        setTitle(title: "افزودن کار")
    }
    
    func initializeTextFields() {
        textFields = [titleTextField, dateTextField]
        data = ["", ""] //0: title, 1: clinic
        setTextFieldDelegates()
    }
    
    func setTextFieldDelegates() {
        textFieldDelegates = [TextFieldDelegate(viewController: self, isForPrice: false, isForDate: false), TextFieldDelegate(viewController: self, isForPrice: false, isForDate: true)]
        for i in 0 ..< 2 {
            textFields[i].delegate = textFieldDelegates[i]
        }
    }
    
    //MARK: Clinic Functions
    func prepareClinicMenu() {
        getClinics()
        if clinicOptions.count > 0 {
            setClinicMenuDelegates()
        }
    }
    
    func getClinics() {
        clinicOptions.removeAll()
        if let clinics = Info.dataController.fetchAllClinics() as? [Clinic] {
            for clinic in clinics {
                clinicOptions.append(clinic.title)
            }
        }
    }
    
    func setClinicMenuDelegates() {
        clinicMenu.delegate = self
        clinicMenu.options = clinicOptions
        clinicMenu.collapsingAnimationStyle = .spring(level: .low)
    }
    
    func didSelectOption(_ swiftyMenu: SwiftyMenu, _ selectedOption: SwiftMenuDisplayable, _ index: Int) {
        data[1] = selectedOption.displayValue
    }
    
    //MARK: User Flow
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
        if data[0] as? String == "" {
            return textFields[0]
        }
        if date == nil {
            return textFields[1]
        }
        return nil
    }
    
    override func saveData() {
//        let task = Task.getTask(id: nil, title: taskData[0], date: date!, clinic: taskData[1],)
//        RestAPIManagr.sharedInstance.addTask(finance: task)
    }
}
