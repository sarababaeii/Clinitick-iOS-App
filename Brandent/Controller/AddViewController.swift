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
    
    var currentTextField: UITextField?
    
    //MARK: Logical Variables:
    var hasAlergy: Bool = false
    var date: Date?
    var appointmentData = ["", "", "", -1, "", ""] as [Any]
    //0: name, 1: phone, 2: disease, 3: price, 4: alergy, 5: notes
    
    
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
    
    @IBAction func editingStarted(_ sender: Any) {
        if let textField = sender as? UITextField {
            currentTextField = textField
        }
    }
    
    @IBAction func next(_ sender: Any) {
        if let textField = sender as? UITextField, let text = textField.fetchInput() {
            if textField.tag == 3 {
                if let price = Int(text) {
                    appointmentData[textField.tag] = price
                    print("&& \(price)")
                    textField.text = "\(String(price).convertEnglishNumToPersianNum()) تومان"
                }
            } else {
                appointmentData[textField.tag] = text
            }
            print("$$ \(text)")
        }
    }
    
    @IBAction func addPhoto(_ sender: Any) {
        
    }
    
    func mustComplete() -> CustomTextField? {
        if appointmentData[0] as? String == "" {
            return patientNameTextField
        }
        if appointmentData[1] as? String == "" {
            return patientPhoneNumberTextField
        }
        if appointmentData[2] as? String == "" {
            return diseaseTextField
        }
        if appointmentData[3] as? Int == -1 {
            return priceTextField
        }
        if hasAlergy && appointmentData[4] as? String == "" {
            return alergyTextField
        }
        guard let _ = dateTextField.fetchInput() else {
            return dateTextField
        }
        return nil
    }
    
    @available(iOS 13.0, *)
    @IBAction func submit(_ sender: Any) {
        next(currentTextField as Any)
        currentTextField = nil
        if let requiredTextField = mustComplete() {
            submitionError(for: requiredTextField)
            return
        }
        let _ = Appointment.createAppointment(name: appointmentData[0] as! String, phone: appointmentData[1] as! String, diseaseTitle: appointmentData[2] as! String, price: appointmentData[3] as! Int, alergies: appointmentData[4] as? String, visit_time: date!, notes: appointmentData[5] as? String)

        Info.dataController.loadData()
        back()
    }
    
    func submitionError(for textField: CustomTextField) {
        if textField.placeHolderColor != Color.red.componentColor {
            textField.setPlaceHolderColor(string: "*\(textField.placeholder!)", color: Color.red.componentColor)
            textField.placeHolderColor = Color.red.componentColor
        }
        self.showToast(message: "خطا: همه‌ی موارد ضروری وارد نشده است.")
    }
    
    @IBAction func returnBack(_ sender: Any) {
        back()
    }
    
    func back() {
        tabBarController?.selectedViewController = Info.sharedInstance.lastViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        creatDatePicker()
    }
}


//TODO: get images
//TODO: next button
//TODO: hide keyboard
//TODO: notes limit

//alergy typed then canceled?

//TODO: cleaning
//TODO: iOS availability

//TODO: auto complete for patient
