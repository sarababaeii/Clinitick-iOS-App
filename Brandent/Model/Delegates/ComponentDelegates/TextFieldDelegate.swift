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
    
    private func getPriceData(_ textField: UITextField) {
        guard let text = textField.fetchInput(), let price = Int(text) else {
            return
        }
        viewController.data[textField.tag] = price
        textField.text = "\(String.toPersianPriceString(price: price)) تومان"
    }
    
    private func getTextData(_ textField: UITextField) {
        if let text = textField.fetchInput() {
            viewController.data[textField.tag] = text
        }
    }
}
