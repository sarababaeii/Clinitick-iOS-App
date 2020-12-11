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
    
    //MARK: User Flow
    @IBAction func editingStarted(_ sender: Any) {
        if let textField = sender as? UITextField {
            currentTextField = textField
        }
    }
    
    @IBAction func textChanged(_ sender: Any) {
        if let textField = sender as? UITextField, let text = textField.fetchInput(), text.count == 1 {
            if textField.tag != 3 {
                next(textField)
            } else {
                //TODO: check code
                nextPage()
            }
        }
    }
    
    @IBAction func editingEnded(_ sender: Any) {
        if let textField = sender as? UITextField, let text = textField.fetchInput() {
            codeDigits[textField.tag] = text //Int(text)?
        }
    }
        
    func next(_ textField: UITextField) {
        textFields[textField.tag + 1].isEnabled = true
        textFields[textField.tag + 1].becomeFirstResponder()
    }
        
    func nextPage() {
        guard let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "InformationViewController") as? InformationViewController else {
            return
        }
        controller.phoneNumber = phoneNumber
        navigationController?.show(controller, sender: nil)
    }
    
    @IBAction func hideKeyboard(_ sender: Any) {
        if let textField = currentTextField {
            textField.resignFirstResponder()
        }
    }
    
    @IBAction func resendCode(_ sender: Any) {
        //TODO: API
        setTimer()
        resendButton.isHidden = true
        //enable?
        resendView.isHidden = false
    }
    
    //MARK: Timer
    func setTimer() {
        timer = TimerDelegate(label: timerLabel, time: 60, from: self)
    }
    
    func timerFinished() {
        resendView.isHidden = true
        resendButton.isHidden = false
        //enable?
    }
    
    //MARK: Initialization
    func configure() {
        textFields = [firstDigitTextField, secondDigitTextField, thirdDigitTextField, fourthDigitTextField]
        setTimer()
        firstDigitTextField.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configure()
    }
}
