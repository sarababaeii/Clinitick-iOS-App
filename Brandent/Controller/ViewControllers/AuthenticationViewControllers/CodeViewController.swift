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
    
    var textFields = [CustomTextField]()
    var currentTextField: UITextField?
    
    var codeDigits = ["", "", "", ""] //0: first digit, 1: socond digit, 2: third digit, 4: fourth digit
    
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
                //TODO: go to next page
            }
        }
    }
    
    @IBAction func editingEnded(_ sender: Any) {
        if let textField = sender as? UITextField, let text = textField.fetchInput() {
            codeDigits[textField.tag] = text //Int(text)?
        }
    }
        
    func next(_ textField: UITextField) {
        textFields[textField.tag + 1].becomeFirstResponder()
    }
        
    @IBAction func hideKeyboard(_ sender: Any) {
        if let textField = currentTextField {
            textField.resignFirstResponder()
        }
    }
    
    @IBAction func resendCode(_ sender: Any) {
    }
    
    func timerFinished() {
        resendView.isHidden = true
        resendButton.isHidden = false
    }
    
    //MARK: Initialization
    func configure() {
        textFields = [firstDigitTextField, secondDigitTextField, thirdDigitTextField, fourthDigitTextField]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configure()
    }
}
