//
//  AddClinicViewController.swift
//  Brandent
//
//  Created by Sara Babaei on 10/30/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//

import Foundation
import UIKit

class AddClinicViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: CustomTextField!
    @IBOutlet weak var addressTextField: CustomTextField!
    
    var textFields = [CustomTextField]()
    var currentTextField: UITextField?
    
    var clinicData = ["", ""] //0: title, 1: address
    
    @IBAction func editingStarted(_ sender: Any) {
        if let textField = sender as? UITextField {
            currentTextField = textField
        }
    }
    
    @IBAction func editingEnded(_ sender: Any) {
        if let textField = sender as? UITextField, let text = textField.fetchInput() {
            clinicData[textField.tag] = text
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
        for i in 0 ..< 2 {
            if clinicData[i] == "" {
                return textFields[i]
            }
        }
        return nil
    }
    
    @IBAction func submit(_ sender: Any) {
        editingEnded(currentTextField as Any)
        currentTextField = nil
        
        if let requiredTextField = mustComplete() {
            submitionError(for: requiredTextField)
            return
        }
        
//        let clinic = Clinic.getClinic(title: clinicData[0], address: clinicData[1])
//        RestAPIManagr.sharedInstance.addClinic(clinic: clinic)
//        
//        back()
    }
    
    func submitionError(for textField: CustomTextField) {
        if textField.placeHolderColor != Color.red.componentColor {
            textField.placeholder = "*\(textField.placeholder!)"
            textField.placeHolderColor = Color.red.componentColor
        }
        self.showToast(message: "خطا: همه‌ی موارد ضروری وارد نشده است.")
    }
}
