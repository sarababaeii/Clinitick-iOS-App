//
//  CodeViewController.swift
//  Brandent
//
//  Created by Sara Babaei on 12/9/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//

import Foundation
import UIKit

class CodeViewController: UIViewController {
    
    @IBOutlet weak var firstDigitTextField: CustomTextField!
    @IBOutlet weak var secondDigitTextField: CustomTextField!
    @IBOutlet weak var thirdDigitTextField: CustomTextField!
    @IBOutlet weak var fourthDigitTextField: CustomTextField!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var resendView: CustomUIView!
    @IBOutlet weak var resendButton: CustomButton!
    
    var timer: TimerDelegate?
    
    var textFields = [CustomTextField]()
    var currentTextField: UITextField?
    
    var codeDigits = ["", "", "", ""] //0: first digit, 1: socond digit, 2: third digit, 4: fourth digit
    var phoneNumber = ""
    
    //MARK: Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    func configure() {
        textFields = [firstDigitTextField, secondDigitTextField, thirdDigitTextField, fourthDigitTextField]
        setTimer()
        firstDigitTextField.becomeFirstResponder()
    }
    
    //MARK: TextFields Functions
    @IBAction func editingStarted(_ sender: Any) {
        if let textField = sender as? UITextField {
            currentTextField = textField
            textField.text = ""
        }
    }
    
    @IBAction func textChanged(_ sender: Any) {
        if let textField = sender as? UITextField, let text = textField.fetchInput(), text.count == 1 {
            if textField.tag != 3 {
                next(textField)
            } else {
                textField.resignFirstResponder()
            }
            sendCode()
        }
    }
    
    @IBAction func editingEnded(_ sender: Any) {
        guard let textField = sender as? UITextField else {
            return
        }
        if let text = textField.fetchInput() {
            codeDigits[textField.tag] = text
        } else {
            codeDigits[textField.tag] = ""
        }
    }
        
    func next(_ textField: UITextField) {
        textFields[textField.tag + 1].isEnabled = true
        textFields[textField.tag + 1].becomeFirstResponder()
    }
    
    //MARK: Keyboard Management
    @IBAction func hideKeyboard(_ sender: Any) {
        if let textField = currentTextField {
            textField.resignFirstResponder()
        }
    }
    
    //MARK: Timer
    func setTimer() {
        timer = TimerDelegate(label: timerLabel, time: 60, from: self)
    }
    
    func timerFinished() {
        changeResendCodeVisiblity()
    }
    
    //MARK: Resending Code
    @IBAction func resendCode(_ sender: Any) {
        RestAPIManagr.sharedInstance.getOneTimeCode(phone: phoneNumber, {(statusCode) in
            self.checkResponse(statusCode: statusCode)
        })
        setTimer()
        changeResendCodeVisiblity()
    }
    
    func changeResendCodeVisiblity() {
        resendView.isHidden = !resendView.isHidden
        resendButton.isHidden = !resendButton.isHidden
    }
    
    func checkResponse(statusCode: Int) {
        switch statusCode {
        case 200:
            self.showToast(message: "ارسال شد.")
        case 401:
            self.showToast(message: "شماره موبایل تکراری است.")
        default:
            self.showToast(message: "خطایی رخ داده است.")
        }
    }
    
    //MARK: Submission
    func getEnteredCode() -> String {
        var code = ""
        for digit in codeDigits {
            code += digit
        }
        return code
    }
    
     func sendCode() {
        let code = getEnteredCode()
        guard code.count == 4 else {
            return
        }
        currentTextField?.resignFirstResponder()
        RestAPIManagr.sharedInstance.sendOneTimeCode(phone: phoneNumber, code: code, {(isValid) in
            if isValid {
                self.nextPage()
            } else {
                self.invalidCode()
            }
        })
    }
    
    func invalidCode() {
        self.showToast(message: "کد وارد شده اشتباه است.")
        for i in 0 ..< 4 {
            codeDigits[i] = ""
            textFields[i].text = ""
            if i != 0 {
                textFields[i].isEnabled = false
            }
        }
        firstDigitTextField.becomeFirstResponder()
    }
    
    func nextPage() {
        guard let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "InformationViewController") as? InformationViewController else {
            return
        }
        controller.phoneNumber = phoneNumber
        navigationController?.show(controller, sender: nil)
    }
}
