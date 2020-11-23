//
//  AddDiseaseViewController.swift
//  Brandent
//
//  Created by Sara Babaei on 10/30/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//

import Foundation
import UIKit

class AddDiseaseViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: CustomTextField!
    @IBOutlet weak var priceTextField: CustomTextField!
    
    var textFields = [CustomTextField]()
    var currentTextField: UITextField?
    
    var diseaseData = ["", -1] as [Any] //0: title, 1: price
    
    
    @IBAction func editingStarted(_ sender: Any) {
        if let textField = sender as? UITextField {
            currentTextField = textField
//            if textField.tag == 1 {
//                textField.text = nil
//            }
        }
    }
    
    @IBAction func editingEnded(_ sender: Any) {
        if let textField = sender as? UITextField, let text = textField.fetchInput() {
            if textField.tag == 1 {
                if let price = Int(text) {
                    diseaseData[textField.tag] = price
                    textField.text = "\(String.toPersianPriceString(price: price)) تومان"
                }
            } else {
                diseaseData[textField.tag] = text
            }
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
        if diseaseData[0] as! String == "" {
            return textFields[0]
        }
        if diseaseData[1] as! Int == -1 {
            return textFields[1]
        }
        return nil
    }
    
    
    func submitionError(for textField: CustomTextField) {
        if textField.placeHolderColor != Color.red.componentColor {
            textField.placeholder = "*\(textField.placeholder!)"
            textField.placeHolderColor = Color.red.componentColor
        }
        self.showToast(message: "خطا: همه‌ی موارد ضروری وارد نشده است.")
    }
    
    @available(iOS 13.0, *)
    @IBAction func submit(_ sender: Any) {
        editingEnded(currentTextField as Any)
        currentTextField = nil

        if let requiredTextField = mustComplete() {
            submitionError(for: requiredTextField)
            return
        }

        let disease = Disease.getDisease(id: nil, title: diseaseData[0] as! String, price: diseaseData[1] as! Int)
//        RestAPIManagr.sharedInstance.addDisease(disease: disease)

        back()
    }
    
    func back() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func configure() {
        textFields = [titleTextField, priceTextField]
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "افزودن بیماری‌", style: UIBarButtonItem.Style.plain, target: self, action: .none)
        self.navigationItem.rightBarButtonItem?.setTitleTextAttributes([ NSAttributedString.Key.font: UIFont(name: "Vazir-Bold", size: 26.0)!], for: .normal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configure()
    }
}
