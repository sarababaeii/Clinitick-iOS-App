//
//  LoginViewController.swift
//  Brandent
//
//  Created by Sara Babaei on 12/9/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var phoneNumberTextField: CustomTextField!
    @IBOutlet weak var passwordTextField: CustomTextField!
    
    var textFields = [CustomTextField]()
    var currentTextField: UITextField?
    
    var dentistData = ["", ""] //0: phone number, 1: password
    
    //MARK: User Flow
    @IBAction func editingStarted(_ sender: Any) {
        if let textField = sender as? UITextField {
            currentTextField = textField
        }
    }
        
    @IBAction func editingEnded(_ sender: Any) {
        if let textField = sender as? UITextField, let text = textField.fetchInput() {
            dentistData[textField.tag] = text
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
    func mustComplete() -> CustomTextField? {
        for i in 0 ..< 2 {
            if dentistData[i] == "" {
                return textFields[i]
            }
        }
        return nil
    }
        
    func submitionError(for textField: CustomTextField) {
        textField.showError()
        self.showToast(message: "خطا: همه‌ی موارد ضروری وارد نشده است.")
    }
    
    @IBAction func login(_ sender: Any) {
        editingEnded(currentTextField as Any)
        currentTextField = nil

        if let requiredTextField = mustComplete() {
            submitionError(for: requiredTextField)
            return
        }
        
        RestAPIManagr.sharedInstance.login(phone: dentistData[0], password: dentistData[1])
        if let _ = Info.sharedInstance.token {
            self.showNextPage(identifier: "TabBarViewController")
        }
//        let dentist = Dentist.getDentist(firstName: dentistData[0], lastName: dentistData[1], speciality: dentistData[2], phone: dentistData[3], password: dentistData[4])
    }
    
    @IBAction func signUp(_ sender: Any) {
        editingEnded(currentTextField as Any)
        currentTextField = nil
        nextPage()
    }
    
    func nextPage() {
        guard let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController else {
            return
        }
        if dentistData[0] != "" {
            controller.phoneNumber = dentistData[0]
        }
        navigationController?.show(controller, sender: nil)
    }
    
    //MARK: Initialization
    func configure() {
        textFields = [phoneNumberTextField, passwordTextField]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configure()
    }
}
