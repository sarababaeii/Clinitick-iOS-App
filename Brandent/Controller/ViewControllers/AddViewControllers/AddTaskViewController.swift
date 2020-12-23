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

class AddTaskViewController: FormViewController {
    
    @IBOutlet weak var titleTextField: CustomTextField!
    @IBOutlet weak var dateTextField: CustomTextField!
    @IBOutlet weak var clinicMenu: SwiftyMenu!
    
    var textFieldDelegates = [TextFieldDelegate]()
    var menuDelegate: MenuDelegate?
    
    //MARK: Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    func configure() {
        initializeTextFields()
        setMenuDelegate()
        setDatePicker(dateTextFieldIndex: 1, mode: .dateAndTime)
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
    
    func setMenuDelegate() {
        menuDelegate = MenuDelegate(viewController: self, menuDataIndex: 1)
        menuDelegate!.prepareClinicMenu(menu: clinicMenu)
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
        let _ = Task.getTask(title: data[0] as! String, date: date!, clinicTitle: data[1] as? String)
//        RestAPIManagr.sharedInstance.addTask(finance: task)
    }
}
