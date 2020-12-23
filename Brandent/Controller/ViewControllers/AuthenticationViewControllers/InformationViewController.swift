//
//  InformationViewController.swift
//  Brandent
//
//  Created by Sara Babaei on 12/9/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//

import Foundation
import UIKit

class InformationViewController: FormViewController {
    
    @IBOutlet weak var firstNameTextField: CustomTextField!
    @IBOutlet weak var lastNameTextField: CustomTextField!
    @IBOutlet weak var specialityTextField: CustomTextField!
    @IBOutlet weak var clinicTitleTextField: CustomTextField!
    @IBOutlet weak var phoneNumberTextField: CustomTextField!
    @IBOutlet weak var passwordTextField: CustomTextField!
    
    var textFieldDelegates = [TextFieldDelegate]()
    
    var phoneNumber = ""
    
    //MARK: Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    func configure() {
        initializeTextFields()
        setPhoneNumber()
    }
    
    func initializeTextFields() {
        textFields = [firstNameTextField, lastNameTextField, specialityTextField, clinicTitleTextField, passwordTextField, phoneNumberTextField]
        data = ["", "", "", "", "", ""] as [String] //0: first name, 1: last name, 2: speciality, 3: clinicTitle, 4: password, 5: phone number
        setTextFieldDelegates()
    }
    
    func setTextFieldDelegates() {
        textFieldDelegates = [
            TextFieldDelegate(viewController: self, isForPrice: false, isForDate: false),
            TextFieldDelegate(viewController: self, isForPrice: false, isForDate: false),
            TextFieldDelegate(viewController: self, isForPrice: false, isForDate: false),
            TextFieldDelegate(viewController: self, isForPrice: false, isForDate: false),
            TextFieldDelegate(viewController: self, isForPrice: false, isForDate: false)]
        for i in 0 ..< 5 {
            textFields[i].delegate = textFieldDelegates[i]
        }
    }
    
    //MARK: UI Setting
    func setPhoneNumber() {
        phoneNumberTextField.text = phoneNumber
        data[5] = phoneNumber
    }
    
    //MARK: Keyboard Management
    @IBAction func hideKeyboard(_ sender: Any) {
        if let textField = currentTextField {
            textField.resignFirstResponder()
        }
    }
        
    //MARK: Submission
    @IBAction func signUp(_ sender: Any) {
       getLastData()
        if let requiredTextField = mustComplete() {
            submitionError(for: requiredTextField)
            return
        }
        
        let dentist = Dentist.getDentist(id: nil, firstName: data[0] as! String, lastName: data[1] as! String, phone: data[5] as! String, speciality: data[2] as! String, clinicTitle: data[3] as! String, password: data[4] as! String)
        print(dentist)
        RestAPIManagr.sharedInstance.signUp(dentist: dentist)
        
        if let _ = Info.sharedInstance.token {
            nextPage2()
        }
    }
    
    override func mustComplete() -> Any? {
        for i in 0 ..< 6 {
            if data[i] as? String == "" {
                print(i)
                return textFields[i]
            }
        }
        return nil
    }
    
    func nextPage2() {
        guard let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBarViewController") as? UITabBarController else {
            return
        }
        navigationController?.show(controller, sender: nil)
    }
}
