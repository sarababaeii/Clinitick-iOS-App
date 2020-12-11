//
//  InformationViewController.swift
//  Brandent
//
//  Created by Sara Babaei on 12/9/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//

import Foundation
import UIKit

class InformationViewController: UIViewController {
    
    @IBOutlet weak var firstNameTextField: CustomTextField!
    @IBOutlet weak var lastNameTextField: CustomTextField!
    @IBOutlet weak var specialityTextField: CustomTextField!
    @IBOutlet weak var phoneNumberTextField: CustomTextField!
    @IBOutlet weak var passwordTextField: CustomTextField!
    
    var textFields = [CustomTextField]()
    var currentTextField: UITextField?
    
    var dentistData = ["", "", "", "", ""] as [String] //0: first name, 1: last name, 2: speciality, 3: password, 4: phone number
    var phoneNumber = ""
    
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
        for i in 0 ..< 5 {
            if dentistData[i] == "" {
                print(i)
                return textFields[i]
            }
        }
        return nil
    }
        
    func submitionError(for textField: CustomTextField) {
        textField.showError()
        self.showToast(message: "خطا: همه‌ی موارد ضروری وارد نشده است.")
    }
    
    @IBAction func signUp(_ sender: Any) {
        editingEnded(currentTextField as Any)
        currentTextField = nil

        if let requiredTextField = mustComplete() {
            submitionError(for: requiredTextField)
            return
        }
        
        let dentist = Dentist.getDentist(id: nil, firstName: dentistData[0], lastName: dentistData[1], phone: dentistData[4], speciality: dentistData[2], password: dentistData[3])
        print(dentist)
        RestAPIManagr.sharedInstance.signUp(dentist: dentist)
//        RestAPIManagr.sharedInstance.addDisease(disease: disease)
        //TODO: Next page
    }
    
    //MARK: UI Setting
    func setPhoneNumber() {
        phoneNumberTextField.text = phoneNumber
        dentistData[4] = phoneNumber
    }
    
    //MARK: Initialization
    func configure() {
        textFields = [firstNameTextField, lastNameTextField, specialityTextField, passwordTextField, phoneNumberTextField]
        setPhoneNumber()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configure()
    }
}
