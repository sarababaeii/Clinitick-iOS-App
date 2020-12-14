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

class AddTaskViewController: UIViewController, SwiftyMenuDelegate {
    
    @IBOutlet weak var titleTextField: CustomTextField!
    @IBOutlet weak var dateTextField: CustomTextField!
    @IBOutlet weak var clinicMenu: SwiftyMenu!
    
    let datePicker = UIDatePicker()
    var clinicOptions = [String]()
    
    var textFields = [CustomTextField]()
    var currentTextField: UITextField?
    var taskData = ["", ""] //0: title, 2: clinic
    var date: Date?
    
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
        taskData[2] = selectedOption.displayValue
    }
    
    //MARK: DatePicker Functions
    func creatDatePicker() {
        datePicker.createPersianDatePicker(mode: .date)
        dateTextField.inputView = datePicker
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        dateTextField.inputAccessoryView = toolbar
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([doneButton], animated: true )
    }
    
    @objc func donePressed() {
        dateTextField.text = datePicker.date.toPersianDMonthYString()
        dateTextField.endEditing(true)
        date = datePicker.date
    }
    
    //MARK: TextFields Functions
    @IBAction func editingStarted(_ sender: Any) {
        if let textField = sender as? UITextField {
            currentTextField = textField
        }
    }
    
    @IBAction func editingEnded(_ sender: Any) {
        if let textField = sender as? UITextField, let text = textField.fetchInput() {
            taskData[textField.tag] = text
        }
    }
    
    @IBAction func next(_ sender: Any) {
        if let textField = sender as? UITextField {
            textFields[textField.tag + 1].becomeFirstResponder()
        }
    }
    
    @IBAction func hideKeyboard(_ sender: Any) {
        if let textField = currentTextField {
            textField.resignFirstResponder()
        }
    }
    
    //MARK: Submission
    @IBAction func submit(_ sender: Any) {
        editingEnded(currentTextField as Any)
        currentTextField = nil

        if let requiredItem = mustComplete() {
            submitionError(for: requiredItem)
            return
        }

//        let task = Task.getTask(id: nil, title: taskData[0], date: date!, clinic: taskData[1],)
//        RestAPIManagr.sharedInstance.addTask(finance: task)

        back()
    }
    
    func mustComplete() -> CustomTextField? {
        if taskData[0] == "" {
            return textFields[0]
        }
        if date == nil {
            return textFields[1]
        }
        return nil
    }
    
    //MARK: Showing Error
    func submitionError(for textField: CustomTextField) {
        textField.showError()
        self.showToast(message: "خطا: همه‌ی موارد ضروری وارد نشده است.")
    }
    
    func back() {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: UI Management
    func setTitle() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "افزودن کار", style: UIBarButtonItem.Style.plain, target: self, action: .none)
        self.navigationItem.rightBarButtonItem?.setTitleTextAttributes([ NSAttributedString.Key.font: UIFont(name: "Vazir-Bold", size: 22.0)!], for: .normal)
    }
    
    func configure() {
        setTitle()
        textFields = [titleTextField, dateTextField]
        prepareClinicMenu()
        creatDatePicker()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    //MARK: Showing NavigationBar
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}
