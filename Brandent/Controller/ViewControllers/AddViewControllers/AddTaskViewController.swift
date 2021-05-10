//
//  AddTask.swift
//  Brandent
//
//  Created by Sara Babaei on 12/13/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//

import Foundation
import UIKit

class AddTaskViewController: FormViewController {
    
    @IBOutlet weak var titleTextField: CustomTextField!
    @IBOutlet weak var dateTextField: CustomTextField!
    @IBOutlet weak var clinicMenu: SwiftyMenu!
    
    var textFieldDelegates = [TextFieldDelegate]()
    var menuDelegate: ClinicMenuDelegate?
    
    var task: Task?
    
    //MARK: Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    func configure() {
        setMenuDelegate()
        initializeTextFields()
        setDatePicker(dateTextFieldIndex: 1, mode: .dateAndTime)
        setTitle(title: "افزودن کار")
    }
    
    func initializeTextFields() {
        textFields = [titleTextField, dateTextField]
        data = ["", ""] //0: title, 1: clinic
        setTextFieldDelegates()
        setTextFieldsData()
    }
    
    func setTextFieldsData() {
        if let task = task {
            titleTextField.text = task.title
            dateTextField.text = task.date.toCompletePersianString()
            if let clinic = task.clinic {
                clinicMenu.selectOption(option: clinic.title)
            }
            data = [task.title, task.clinic?.title as Any]
            super.date = task.date
        }
    }
    
    func setTextFieldDelegates() {
        textFieldDelegates = [TextFieldDelegate(viewController: self),
                              DateTextFieldDelegate(viewController: self)]
        for i in 0 ..< 2 {
            textFields[i].delegate = textFieldDelegates[i]
        }
    }
    
    func setMenuDelegate() {
        menuDelegate = ClinicMenuDelegate(viewController: self, menuDataIndex: 1)
        menuDelegate!.prepareMenu(menu: clinicMenu)
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
        if data[0] as? String == "" {
            return textFields[0]
        }
        if date == nil {
            return textFields[1]
        }
        return nil
    }
    
    override func saveData() {
        let _ = Task.getTask(id: self.task?.id, title: data[0] as! String, date: date!, state: self.task?.state ?? TaskState.todo.rawValue, clinicTitle: data[1] as? String, isDeleted: nil, modifiedTime: Date())
        Info.sharedInstance.sync()
    }
}
