//
//  NewPassViewController.swift
//  Brandent
//
//  Created by Emad Kazemi on 5/11/1400 AP.
//  Copyright © 1400 AP Sara Babaei. All rights reserved.
//

import Foundation
import UIKit

class NewPassViewController: FormViewController {
    
    @IBOutlet weak var newPasswordTextField: CustomTextField!
    
    var textFieldDelegate: TextFieldDelegate?
    
    var phoneNumber = ""
    var token = ""
    
    //MARK: Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    func configure() {
        initializeTextFields()
    }
    
    func initializeTextFields() {
        textFields = [newPasswordTextField]
        data = [""] as [Any] //0: password
        setTextFieldDelegates()
    }
    
    func setTextFieldDelegates() {
        textFieldDelegate = TextFieldDelegate(viewController: self)
        textFields[0].delegate = textFieldDelegate
    }
    
    //MARK: Keyboard Management
    @IBAction func hideKeyboard(_ sender: Any) {
        if let textField = currentTextField {
            textField.resignFirstResponder()
        }
    }
    
    @IBAction func save(_ sender: Any) {
        currentTextField = newPasswordTextField
        getLastData()

        if let requiredTextField = mustComplete() {
            submitionError(for: requiredTextField)
            return
        }
        
        RestAPIManagr.sharedInstance.resetPassword(phone: phoneNumber, password: data[0] as! String, token: token, {(statusCode) in
            self.checkResponse(statusCode: statusCode)
        })
    }
    
    override func mustComplete() -> Any? {
        if data[0] as? String == "" {
            return newPasswordTextField
        }
        return nil
    }
    
    func checkResponse(statusCode: Int) {
        switch statusCode {
        case 200:
//            self.showToast(message: "ارسال شد.")
            nextPage()
        case 400:
            self.showToast(message: "رمز خالی است.")
        case 401:
            self.showToast(message: "توکن اشتباه است.")
        case 404:
            self.showToast(message: "شماره موبایل ثبت نشده است.")
        default:
            self.showToast(message: "خطایی رخ داده است.")
        }
    }
    
    func nextPage() {
        guard let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBarViewController") as? UITabBarController else {
            return
        }
        navigationController?.show(controller, sender: nil)
    }
}
