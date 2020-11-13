//
//  AddFinanceViewController.swift
//  Brandent
//
//  Created by Sara Babaei on 11/3/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//

import Foundation
import UIKit
import SwiftyMenu

class AddFinanceViewConrtoller: UIViewController, SwiftyMenuDelegate {
    
    @IBOutlet weak var titleTextField: CustomTextField!
    @IBOutlet weak var priceTextField: CustomTextField!
    @IBOutlet weak var kindMenu: SwiftyMenu!
    @IBOutlet weak var dateTextField: CustomTextField!
    
    let kindOptions = ["درآمد", "هزینه"]
    let datePicker = UIDatePicker()
    
    var textFields = [CustomTextField]()
    var currentTextField: UITextField?
    var financeData = ["", -1, ""] as [Any] //0: title, 1: price, 2: isIncome, 3: date
    var isCost: Bool?
    var date: Date?
    
    //MARK: DropDownMenu Functions
    func setKindMenuDelegates() {
        kindMenu.delegate = self
        kindMenu.options = kindOptions
        kindMenu.collapsingAnimationStyle = .spring(level: .low)
    }
    
    func didSelectOption(_ swiftyMenu: SwiftyMenu, _ selectedOption: SwiftMenuDisplayable, _ index: Int) {
        switch index {
        case 0:
            isCost = false
        case 1:
            isCost = true
        default:
            isCost = nil
        }
    }
    
    //MARK: DatePicker Functions
    func creatDatePicker() {
        datePicker.createPersianDatePicker(mode: .date)
        dateTextField.inputView = datePicker
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        dateTextField.inputAccessoryView = toolbar
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([doneButton], animated: true )
    }
    
    @objc func donePressed() {
        dateTextField.text = datePicker.date.toPersianDMonthYString()
        dateTextField.endEditing(true)
        date = datePicker.date
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
            textField.resignFirstResponder()
        }
    }
    
    //MARK: Submission
    @available(iOS 13.0, *)
    @IBAction func submit(_ sender: Any) {
        editingEnded(currentTextField as Any)
        currentTextField = nil

        if let requiredItem = mustComplete() {
            submitionError(for: requiredItem)
            return
        }

        let finance = Finance.getFinance(title: financeData[0] as! String, amount: financeData[1] as! Int, isCost: isCost!, date: date!)
        RestAPIManagr.sharedInstance.addFinance(finance: finance)

        back()
    }
    
    func mustComplete() -> Any? {
        for i in 0 ..< 3 {
            if ((i == 0 || i == 2) && financeData[i] as! String == "") ||
                (i == 1 && financeData[i] as! Int == -1) {
                return textFields[i]
            }
        }
        if isCost == nil {
            return kindMenu
        }
        return nil
    }
    
    //MARK: Showing Error
    func submitionError(for requiredItem: Any) {
        if let textField = requiredItem as? CustomTextField {
            textField.showError()
        }
        else if let menu = requiredItem as? SwiftyMenu {
            menu.showError()
        }
        self.showToast(message: "خطا: همه‌ی موارد ضروری وارد نشده است.")
    }
    
    func back() {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: Initialization
    func configure() {
        textFields = [titleTextField, priceTextField, dateTextField]
        setKindMenuDelegates()
        creatDatePicker()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configure()
    }
}

//errors are not in order
