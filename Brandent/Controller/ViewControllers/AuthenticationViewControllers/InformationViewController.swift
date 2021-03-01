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
    
    @IBOutlet weak var dentistImageView: CustomImageView!
    @IBOutlet weak var addImageButton: UIButton!
    @IBOutlet weak var firstNameTextField: CustomTextField!
    @IBOutlet weak var lastNameTextField: CustomTextField!
    @IBOutlet weak var specialityTextField: CustomTextField!
    @IBOutlet weak var clinicTitleTextField: CustomTextField!
//    @IBOutlet weak var phoneNumberTextField: CustomTextField!
    @IBOutlet weak var passwordTextField: CustomTextField!
    
    var imagePickerDelegate: ProfileImagePickerDelegate?
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
        setDelegates()
    }
    
    func initializeTextFields() {
        textFields = [firstNameTextField, lastNameTextField, specialityTextField, clinicTitleTextField, passwordTextField]
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
    
    func setDelegates() {
        DispatchQueue.main.async {
            self.imagePickerDelegate = ProfileImagePickerDelegate(from: self)
        }
    }
    
    //MARK: UI Setting
    func setPhoneNumber() {
//        phoneNumberTextField.text = phoneNumber
        data[5] = phoneNumber
    }
    
    //MARK: Keyboard Management
    @IBAction func hideKeyboard(_ sender: Any) {
        if let textField = currentTextField {
            textField.resignFirstResponder()
        }
    }
        
    @IBAction func setProfileImage(_ sender: Any) {
        imagePickerDelegate?.displayImagePickingOptions()
    }
    
    //MARK: Submission
    @IBAction func signUp(_ sender: Any) {
       getLastData()
        if let requiredTextField = mustComplete() {
            submitionError(for: requiredTextField)
            return
        }
        
        let dentist = DummyDentist(first_name: data[0] as! String, last_name: data[1] as! String, phone: data[5] as! String, password: data[4] as! String, speciality: data[2] as! String, clinicTitle: data[3] as! String)
        print("Dummy Dentist is: \(dentist)")
        let statusCode = RestAPIManagr.sharedInstance.signUp(dentist: dentist)
        checkResponse(statusCode: statusCode)
    }
    
    override func mustComplete() -> Any? {
        for i in 0 ..< 5 {
            if data[i] as? String == "" {
                print(i)
                return textFields[i]
            }
        }
        return nil
    }
    
    func checkResponse(statusCode: Int) {
        switch statusCode {
        case 200:
            if let _ = Info.sharedInstance.token {
                nextPage2()
            }
        case 403:
            self.showToast(message: "شماره موبایل تکراری است.")
        default:
            self.showToast(message: "خطایی رخ داده است.")
        }
    }
    
    func nextPage2() {
        guard let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBarViewController") as? UITabBarController else {
            return
        }
        navigationController?.show(controller, sender: nil)
    }
}
