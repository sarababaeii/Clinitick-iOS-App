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
    }
    
}
