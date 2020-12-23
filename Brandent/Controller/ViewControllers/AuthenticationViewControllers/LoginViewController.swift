//
//  LoginViewController.swift
//  Brandent
//
//  Created by Sara Babaei on 12/9/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController: FormViewController {
    
    @IBOutlet weak var phoneNumberTextField: CustomTextField!
    @IBOutlet weak var passwordTextField: CustomTextField!
    
    var textFieldDelegates = [TextFieldDelegate]()
    
    //MARK: Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    func configure() {
        initializeTextFields()
    }
    
    func initializeTextFields() {
        textFields = [phoneNumberTextField, passwordTextField]
        data = ["", ""] //0: phone number, 1: password
        setTextFieldDelegates()
    }
    
    func setTextFieldDelegates() {
        textFieldDelegates = [
            TextFieldDelegate(viewController: self, isForPrice: false, isForDate: false),
            TextFieldDelegate(viewController: self, isForPrice: false, isForDate: false)]
        for i in 0 ..< 2 {
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
    @IBAction func login(_ sender: Any) {
        getLastData()

        if let requiredTextField = mustComplete() {
            submitionError(for: requiredTextField)
            return
        }
        
        RestAPIManagr.sharedInstance.login(phone: data[0] as! String, password: data[1] as! String)
        if let _ = Info.sharedInstance.token {
            nextPage2()
        }
//        let dentist = Dentist.getDentist(firstName: dentistData[0], lastName: dentistData[1], speciality: dentistData[2], phone: dentistData[3], password: dentistData[4])
    }
    
    override func mustComplete() -> Any? {
        for i in 0 ..< 2 {
            if data[i] as? String == "" {
                return textFields[i]
            }
        }
        return nil
    }
    
    @IBAction func signUp(_ sender: Any) {
        getLastData()
        nextPage()
    }
    
    func nextPage() {
        guard let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController else {
            return
        }
        if data[0] as? String != "" {
            controller.phoneNumber = self.data[0] as! String
        }
        navigationController?.show(controller, sender: nil)
    }
    
    func nextPage2() {
        guard let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBarViewController") as? UITabBarController else {
            return
        }
        navigationController?.show(controller, sender: nil)
    }
}
