//
//  TextFieldDelegate.swift
//  Brandent
//
//  Created by Sara Babaei on 12/16/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//

import Foundation
import UIKit

class TextFieldDelegate: NSObject, UITextFieldDelegate {
    
    var viewController: FormViewController
    var isForPrice: Bool
    var isForDate: Bool
    
    //MARK: Initialization
    init(viewController: FormViewController, isForPrice: Bool, isForDate: Bool) {
        self.viewController = viewController
        self.isForPrice = isForPrice
        self.isForDate = isForDate
    }
    
    //MARK: Begin Editing
    func textFieldDidBeginEditing(_ textField: UITextField) {
        viewController.currentTextField = textField
    }
    
    //MARK: Change Editing
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard isForPrice else {
            return true
        }
        if let text = textField.text, text.count > 0 {
            textField.text = text.toPriceString(separator: ".", willAdd: string)
        }
        return true
    }
    
    //MARK: End Editing
    func textFieldDidEndEditing(_ textField: UITextField) {
        if isForDate {
            return
        }
        if isForPrice {
            getPriceData(textField)
        } else {
            getTextData(textField)
        }
    }
    
    //MARK: Return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if viewController.textFields.count > textField.tag + 1 {
            viewController.textFields[textField.tag + 1].becomeFirstResponder()
        }
        return true
    }
    
    private func getPriceData(_ textField: UITextField) {
        guard let text = textField.fetchInput(), let price = text.toPriceInt() else {
            viewController.data[textField.tag] = ""
            return
        }
        viewController.data[textField.tag] = price
//        textField.text = "\(String.toPersianPriceString(price: price)) تومان"
    } //TODO: Persian numbers
    
    private func getTextData(_ textField: UITextField) {
        if let text = textField.fetchInput() {
            viewController.data[textField.tag] = text
        } else {
            viewController.data[textField.tag] = ""
        }
    }
}
