//
//  SignUpViewController.swift
//  Brandent
//
//  Created by Sara Babaei on 12/9/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//

import Foundation
import UIKit

class SignUpViewController: FormViewController {
    
    @IBOutlet weak var phoneNumberTextField: CustomTextField!
    
    var textFieldDelegate: TextFieldDelegate?
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
        textFields = [phoneNumberTextField]
        data = [""] as [Any] //0: phone
        setTextFieldDelegates()
    }
    
    func setTextFieldDelegates() {
        textFieldDelegate = TextFieldDelegate(viewController: self, isForPrice: false, isForDate: false)
        textFields[0].delegate = textFieldDelegate
    }
    
    func setPhoneNumber() {
        if phoneNumber != "" {
            data[0] = phoneNumber
            phoneNumberTextField.text = phoneNumber
        }
    }
    
    //MARK: Keyboard Management
    @IBAction func hideKeyboard(_ sender: Any) {
        if let textField = currentTextField {
            textField.resignFirstResponder()
        }
    }
    
    //MARK: Submission
    @IBAction func getCode(_ sender: Any) {
        currentTextField = phoneNumberTextField
        getLastData()

        if let requiredTextField = mustComplete() {
            submitionError(for: requiredTextField)
            return
        }
        
        let statusCode = RestAPIManagr.sharedInstance.getOneTimeCode(phone: data[0] as! String)
        checkResponse(statusCode: statusCode)
    }
    
    override func mustComplete() -> Any? {
        if data[0] as? String == "" {
            return phoneNumberTextField
        }
        return nil
    }
    
    func checkResponse(statusCode: Int) {
        switch statusCode {
        case 200:
            self.showToast(message: "ارسال شد.")
            nextPage()
        case 401:
            self.showToast(message: "شماره موبایل تکراری است.")
        default:
            self.showToast(message: "خطایی رخ داده است.")
        }
    }
    
    func nextPage() {
        guard let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CodeViewController") as? CodeViewController else {
            return
        }
        controller.phoneNumber = data[0] as! String
        navigationController?.show(controller, sender: nil)
    }
}
