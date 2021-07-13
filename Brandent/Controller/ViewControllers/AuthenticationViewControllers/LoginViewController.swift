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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        for i in 0 ..< 2 {
            textFields[i].removeError()
        }
    }
    
    //MARK: Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    func configure() {
        initializeTextFields()
        registerForKeyboardNotifications()
    }
    
    func initializeTextFields() {
        textFields = [phoneNumberTextField, passwordTextField]
        data = ["", ""] //0: phone number, 1: password
        setTextFieldDelegates()
    }
    
    func setTextFieldDelegates() {
        textFieldDelegates = [
            TextFieldDelegate(viewController: self),
            TextFieldDelegate(viewController: self)]
        for i in 0 ..< 2 {
            textFields[i].delegate = textFieldDelegates[i]
            textFields[i].removeError()
        }
    }
    
    //MARK: Keyboard Management
    @IBAction func hideKeyboard(_ sender: Any) {
        if let textField = currentTextField {
            textField.resignFirstResponder()
        }
    }
    
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowOrChange), name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowOrChange), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShowOrChange(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.size.height else {
            return
        }
        adjustLayoutForKeyboard(targetHight: -keyboardSize)
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        adjustLayoutForKeyboard(targetHight: 0)
    }
        
    func adjustLayoutForKeyboard(targetHight: CGFloat){
        self.view.frame.origin.y = targetHight
    }
    
    //MARK: Submission
    @IBAction func login(_ sender: Any) {
        getLastData()

        if let requiredTextField = mustComplete() {
            submitionError(for: requiredTextField)
            return
        }
        
        RestAPIManagr.sharedInstance.login(phone: data[0] as! String, password: data[1] as! String, {(statusCode) in
            self.checkResponse(statusCode: statusCode)
        })
    }
    
    override func mustComplete() -> Any? {
        for i in 0 ..< 2 {
            if data[i] as? String == "" {
                return textFields[i]
            }
        }
        return nil
    }
    
    func checkResponse(statusCode: Int) {
        switch statusCode {
        case 200:
            if let _ = Info.sharedInstance.token, let _ = Info.sharedInstance.dentist {
                nextPage2()
            }
        case 403:
            self.showToast(message: "نام کاربری یا رمز عبور اشتباه است.")
        default:
            self.showToast(message: "خطایی رخ داده است.")
        }
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
