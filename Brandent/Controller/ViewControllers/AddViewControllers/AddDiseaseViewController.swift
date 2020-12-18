//
//  AddDiseaseViewController.swift
//  Brandent
//
//  Created by Sara Babaei on 10/30/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//

import Foundation
import UIKit

class AddDiseaseViewController: FormViewController {
    
    @IBOutlet weak var titleTextField: CustomTextField!
    @IBOutlet weak var priceTextField: CustomTextField!
    
    var textFieldDelegates = [TextFieldDelegate]()
    
    //MARK: Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    func configure() {
        initializeTextFields()
        setTitle(title: "افزودن بیماری‌")
    }
    
    func initializeTextFields() {
        textFields = [titleTextField, priceTextField]
        data = ["", -1] as [Any] //0: title, 1: price
        setTextFieldDelegates()
    }
    
    func setTextFieldDelegates() {
        textFieldDelegates = [TextFieldDelegate(viewController: self, isForPrice: false, isForDate: false), TextFieldDelegate(viewController: self, isForPrice: true, isForDate: false)]
        for i in 0 ..< 2 {
            textFields[i].delegate = textFieldDelegates[i]
        }
    }
    
    //MARK: User Flow
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
    @available(iOS 13.0, *)
    @IBAction func submit(_ sender: Any) {
        submitForm()
    }
    
    override func mustComplete() -> Any? {
        if data[0] as! String == "" {
            return textFields[0]
        }
        if data[1] as! Int == -1 {
            return textFields[1]
        }
        return nil
    }
    
    override func saveData() {
        let _ = Disease.getDisease(id: nil, title: data[0] as! String, price: data[1] as! Int)
    }
}
