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

        print(dentistData[0])
        print(dentistData[1])
        print(dentistData[2])
        print(dentistData[3])
        print(dentistData[4])
        
//        let dentist = Dentist.getDentist(firstName: dentistData[0], lastName: dentistData[1], speciality: dentistData[2], phone: dentistData[3], password: dentistData[4])
//        RestAPIManagr.sharedInstance.addDisease(disease: disease)
    }
    
    //MARK: Initialization
    func configure() {
        textFields = [firstNameTextField, lastNameTextField, specialityTextField, passwordTextField, phoneNumberTextField]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configure()
    }
}
