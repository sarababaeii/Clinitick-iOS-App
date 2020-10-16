//
//  AddViewController.swift
//  Brandent
//
//  Created by Sara Babaei on 9/14/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//

import Foundation
import UIKit
import Photos
import AVFoundation

class AddViewController: UIViewController, UITextViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    //MARK: UI Variables:
    @IBOutlet weak var patientNameTextField: CustomTextField!
    @IBOutlet weak var patientPhoneNumberTextField: CustomTextField!
    @IBOutlet weak var diseaseTextField: CustomTextField!
    @IBOutlet weak var priceTextField: CustomTextField!
    @IBOutlet weak var alergyTextField: CustomTextField!
    @IBOutlet weak var noAlergyButton: CheckAlergyButton!
    @IBOutlet weak var hasAlergyButton: CheckAlergyButton!
    @IBOutlet weak var dateTextField: CustomTextField!
    @IBOutlet weak var notesTextView: CustomTextView!
    @IBOutlet weak var wordLimitLabel: UILabel!
    
    @IBOutlet weak var submitButton: CustomButton!
    @IBOutlet weak var errorView: CustomUIView!
    
    var textFields = [UITextField]()
    
    let datePicker = UIDatePicker()
    let selectedAlergyButtonImages = [UIImage(named: "white_close"), UIImage(named: "white_tick")]
    let unselectedAlergyButtonImages = [UIImage(named: "black_close"), UIImage(named: "black_tick")]
    var imagePickerDelegate: ImagePickerDelegate?
    
    var currentTextField: UITextField?
    
    //MARK: Logical Variables:
    var hasAlergy: Bool = false
    var date: Date?
    var appointmentData = ["", "", "", -1, "", ""] as [Any]
    //0: name, 1: phone, 2: disease, 3: price, 4: alergy, 5: notes
    
    //MARK: DatePicker Functions
    func creatDatePicker() {
        datePicker.calendar = Calendar(identifier: .persian)
        datePicker.locale = Locale(identifier: "fa_IR")
        datePicker.datePickerMode = .dateAndTime
//        datePicker.backgroundColor = UIColor.red
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
    
    //MARK: Alergy Buttons Functions
    @IBAction func checkAlergySelected(_ sender: Any) {
        if let button = sender as? CheckAlergyButton {
            setHasAlergy(by: button)
            button.visibleSelection()
        }
    }
    
    func setHasAlergy(by button: CheckAlergyButton) {
        hasAlergy = button.hasAlergy()
        alergyTextField.isEnabled = hasAlergy
    }
    
    //MARK: TextFields Functions
    @IBAction func editingStarted(_ sender: Any) {
        if let textField = sender as? UITextField {
            currentTextField = textField
        }
    }
    
    @IBAction func editingEnded(_ sender: Any) {
        if let textField = sender as? UITextField, let text = textField.fetchInput() {
            if textField.tag == 3 {
                if let price = Int(text) {
                    appointmentData[textField.tag] = price
                    textField.text = "\(String(price).convertEnglishNumToPersianNum()) تومان"
                }
            } else {
                appointmentData[textField.tag] = text
            }
        }
    }
    
    @IBAction func next(_ sender: Any) {
        if let textField = sender as? UITextField {
            textFields[textField.tag + 1].becomeFirstResponder()
        }
    }
    
//    @IBAction func hideKeyboard(_ sender: Any) {
//        if let textField = currentTextField {
//            textField.resignFirstResponder()
//        }
//    }
    
    func textViewDidChange(_ textView: UITextView) { //Handle the text changes here
        guard let text = notesTextView.fetchInput() else {
            return
        }
        let remain = calculateRemainigCharacters(string: text)
        if remain <= 20 {
            setWordLimit(amount: remain)
        } else {
            wordLimitLabel.isHidden = true
        }
    }
//
//    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
//        let numberOfChars = newText.count
//        return numberOfChars < 10    // 10 Limit Value
//    }
    
//    @IBAction func typingNotes(_ sender: Any) {
//        guard let text = notesTextField.fetchInput() else {
//            return
//        }
//        let remain = calculateRemainigCharacters(string: text)
//        if remain <= 20 {
//            setWordLimit(amount: remain)
//        } else {
//            wordLimitLabel.isHidden = true
//        }
//    }
//
    func calculateRemainigCharacters(string: String) -> Int {
        return notesTextView.maxLength - string.count
    }
    
    func setWordLimit(amount: Int) {
        let amountString = String(amount).convertEnglishNumToPersianNum()
        wordLimitLabel.text = "+\(amountString)"
        wordLimitLabel.isHidden = false
    }
    
    @IBAction func addPhoto(_ sender: Any) {
        imagePickerDelegate?.displayImagePickingOptions()
    }
    
    //MARK: Submission
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
        editingEnded(currentTextField as Any)
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
    
    func configure() {
        creatDatePicker()
        imagePickerDelegate = ImagePickerDelegate(from: self)
        notesTextView.delegate = self
        
        textFields = [patientNameTextField, patientPhoneNumberTextField, diseaseTextField, priceTextField, alergyTextField, dateTextField]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configure()
    }
}


//TODO: get images
//TODO: notes limit

//alergy typed then canceled?

//TODO: cleaning
//TODO: iOS availability

//TODO: auto complete for patient
