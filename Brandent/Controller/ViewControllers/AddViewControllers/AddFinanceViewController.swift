//
//  AddFinanceViewController.swift
//  Brandent
//
//  Created by Sara Babaei on 11/3/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//

import Foundation
import UIKit

class AddFinanceViewConrtoller: UIViewController {
    
    @IBOutlet weak var titleTextField: CustomTextField!
    @IBOutlet weak var priceTextField: CustomTextField!
    @IBOutlet weak var kindTextField: CustomTextField!
    @IBOutlet weak var dateTextField: CustomTextField!
    
    var textFields = [CustomTextField]()
    var currentTextField: UITextField?
    var pickerViewDelegate: PickerViewDelegate?
    let datePicker = UIDatePicker()
    
    var financeData = ["", -1, -1, ""] as [Any] //0: title, 1: price, 2: isIncome, 3: date
    var isIncome: Bool?
    var date: Date?
    
    //MARK: DatePicker Functions
    func creatDatePicker() {
        datePicker.createPersianDatePicker()
        dateTextField.inputView = datePicker
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        dateTextField.inputAccessoryView = toolbar
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([doneButton], animated: true )
    }
    
    @objc func donePressed() {
        dateTextField.text = datePicker.date.toCompletePersianString()
        dateTextField.endEditing(true)
        date = datePicker.date
    }
    
    //MARK: PickerView Functions
    func createPickerView() {
        let pickerView = UIPickerView()
        pickerViewDelegate = PickerViewDelegate(textField: kindTextField)
        pickerView.delegate = pickerViewDelegate
        kindTextField.inputView = pickerView
        dismissPickerView()
    }
    
    func dismissPickerView() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let button = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.action))
        toolbar.setItems([button], animated: true)
        toolbar.isUserInteractionEnabled = true
        kindTextField.inputAccessoryView = toolbar
    }
    
    @objc func action() {
        guard let delegate = pickerViewDelegate else {
            return
        }
        switch delegate.selectedRow {
        case 0:
            isIncome = true
        case 1:
            isIncome = false
        default:
            isIncome = nil
        }
        kindTextField.text = delegate.options[delegate.selectedRow]
        next(kindTextField as Any)
    }
    
    //MARK: TextFields Functions
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
                    financeData[textField.tag] = price
                    textField.text = "\(String.toPersianPriceString(price: price)) تومان"
                }
            } else {
                financeData[textField.tag] = text
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
            if textField.tag == 2 {
//                action()
            }
            textField.resignFirstResponder()
        }
    }
    
    //MARK: Submission
    func mustComplete() -> CustomTextField? {
        for i in 0 ..< 4 {
            if (i == 0 || i == 3) && financeData[i] as! String == "" {
                return textFields[i]
            } else if i == 1 && financeData[i] as! Int == -1 {
                return textFields[i]
            } else if isIncome == nil {
                return textFields[2]
            }
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

        let finance = Finance.getFinance(title: financeData[0] as! String, amount: financeData[1] as! Int, isCost: true, date: date!)
        RestAPIManagr.sharedInstance.addFinance(finance: finance)

        back()
    }
    
    func back() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func configure() {
        textFields = [titleTextField, priceTextField, kindTextField, dateTextField]
        createPickerView()
        creatDatePicker()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configure()
    }
}

//TODO: set isCost
