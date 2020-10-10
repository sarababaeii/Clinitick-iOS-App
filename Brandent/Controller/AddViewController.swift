//
//  AddViewController.swift
//  Brandent
//
//  Created by Sara Babaei on 9/14/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//

import Foundation
import UIKit

class AddViewController: UIViewController {
    //MARK: UI Variables:
    @IBOutlet weak var patientNameTextField: CustomTextField!
    @IBOutlet weak var patientPhoneNumberTextField: CustomTextField!
    @IBOutlet weak var diseaseTextField: CustomTextField!
    @IBOutlet weak var priceTextField: CustomTextField!
    @IBOutlet weak var alergyTextField: CustomTextField!
    @IBOutlet weak var noAlergyButton: CustomButton!
    @IBOutlet weak var hasAlergyButton: CustomButton!
    @IBOutlet weak var dateTextField: CustomTextField!
    @IBOutlet weak var notesTextField: CustomTextField!
    @IBOutlet weak var wordLimitLabel: UILabel!
    
    @IBOutlet weak var submitButton: CustomButton!
    @IBOutlet weak var errorView: CustomUIView!
    
    let datePicker = UIDatePicker()
    let selectedAlergyButtonImages = [UIImage(named: "white_close"), UIImage(named: "white_tick")]
    let unselectedAlergyButtonImages = [UIImage(named: "black_close"), UIImage(named: "black_tick")]
    
    //MARK: Logical Variables:
    var patientName: String?
    var patientPhoneNumber: String?
    var disease: String?
    var price: Int?
    var hasAlergy: Bool = false
    var alergy: String?
    var date: Date?
    var notes: String?
    
    func creatDatePicker() {
        datePicker.calendar = Calendar(identifier: .persian)
        datePicker.locale = Locale(identifier: "fa_IR")
        datePicker.datePickerMode = .dateAndTime
        dateTextField.inputView = datePicker
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        dateTextField.inputAccessoryView = toolbar
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([doneButton], animated: true )
    }
    
    @objc func donePressed() {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .persian)
        formatter.locale = Locale(identifier: "fa_IR")
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        
        dateTextField.text = formatter.string(from: datePicker.date)
        dateTextField.endEditing(true)
        
        date = datePicker.date
    }
    
    @IBAction func checkAlergySelected(_ sender: Any) {
        setHasAlergy(by: sender as! UIButton)
        visibleSelection(selected: sender as! UIButton)
    }
    
    func setHasAlergy(by button: UIButton) {
        if button.tag == 0 {
            hasAlergy = false
        } else {
            hasAlergy = true
        }
        alergyTextField.isEnabled = hasAlergy
    }
    
    func visibleSelection(selected button: UIButton) {
        selectAlergyButton(button: button)
        if let otherButton = getOtherButton(from: button) {
            unselectAlergyButton(button: otherButton)
        }
    }
    
    func selectAlergyButton(button: UIButton) {
        button.backgroundColor = Color.orange.componentColor
        button.setImage(selectedAlergyButtonImages[button.tag], for: .normal)
    }
    
    func unselectAlergyButton(button: UIButton) {
        button.backgroundColor = UIColor.white
        button.setImage(unselectedAlergyButtonImages[button.tag], for: .normal)
    }
    
    func getOtherButton(from button: UIButton) -> UIButton? {
        guard let siblings = button.superview?.subviews else {
            return nil
        }
        for view in siblings {
            if let btn = view as? UIButton {
                if btn.tag != button.tag {
                    return btn
                }
            }
        }
        return nil
    }
    
    func mustComplete() -> CustomTextField? {
        if let text = patientNameTextField.fetchInput() {
            patientName = text
        } else {
            return patientNameTextField
        }
        if let text = patientPhoneNumberTextField.fetchInput() {
            patientPhoneNumber = text
        } else {
            return patientPhoneNumberTextField
        }
        if let text = diseaseTextField.fetchInput() {
            disease = text
        } else {
            return diseaseTextField
        }
        if let _ = priceTextField.fetchInput() { //TODO: get price
            price = 200000
        } else {
            return priceTextField
        }
        if hasAlergy {
            if let text = alergyTextField.fetchInput() {
                alergy = text
            } else {
                return alergyTextField
            }
        }
        guard let _ = dateTextField.fetchInput() else {
            return dateTextField
        }
        return nil
    }
    
    @available(iOS 13.0, *)
    @IBAction func submit(_ sender: Any) {
        if let requiredTextField = mustComplete() {
            submitionError(for: requiredTextField)
            return
        }
        let _ = Appointment.createAppointment(name: patientName!, phone: patientPhoneNumber!, diseaseTitle: disease!, price: price!, alergies: alergy, visit_time: date!, notes: notes)

        Info.dataController.loadData()
    }
    
    func submitionError(for textField: CustomTextField) {
        if textField.placeHolderColor != Color.red.componentColor {
            textField.setPlaceHolderColor(string: "*\(textField.placeholder!)", color: Color.red.componentColor)
            textField.placeHolderColor = Color.red.componentColor
        }
        self.showToast(message: "خطا: همه‌ی موارد ضروری وارد نشده است.")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        creatDatePicker()
    }
}


//TODO: set price
//TODO: get images
//TODO: cleaning
//TODO: iOS availability
//TODO: return and done
//TODO: next button
//TODO: hide keyboard
//TODO: auto complete for patient
