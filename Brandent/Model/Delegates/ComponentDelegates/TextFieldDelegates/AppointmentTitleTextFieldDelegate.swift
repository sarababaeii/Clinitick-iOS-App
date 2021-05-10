//
//  AppointmentTitleTextFieldDelegate.swift
//  Brandent
//
//  Created by Sara Babaei on 5/10/21.
//  Copyright © 2021 Sara Babaei. All rights reserved.
//

import Foundation
import UIKit

class AppointmentTitleTextFieldDelegate: TextFieldDelegate {
    
    //MARK: Initialization
    init(tableViewCell: AddAppointmentTableViewCell) { //FormViewController or AddAppointmentTableViewCell
        super.init(viewController: tableViewCell)
    }
    
    //MARK: Change Editing
    override func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        enableOtherTextFields(state: true)
        return true
    }
    
    private func enableOtherTextFields(state: Bool) {
        if let tableViewCell = viewController as? AddAppointmentTableViewCell {
            tableViewCell.isFilled = state
            for i in 1 ..< 4 {
                tableViewCell.textFields[i].isEnabled = state
                if !state {
                    tableViewCell.textFields[i].text = ""
                    if i == 1 {
                        tableViewCell.data[i] = ""
                    } else {
                        tableViewCell.date = nil
                    }
                }
            }
        }
    }
    
    //MARK: End Editing
    override func textFieldDidEndEditing(_ textField: UITextField) {
        getTextData(textField)
    }
    
    override func getTextData(_ textField: UITextField) {
        super.getTextData(textField)
        if let _ = textField.fetchInput() {
            enableOtherTextFields(state: true)
        } else {
            enableOtherTextFields(state: false)
        }
    }
}
