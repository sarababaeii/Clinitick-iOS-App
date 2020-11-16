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
import SwiftyMenu

class AddViewController: UIViewController, UITextViewDelegate, SwiftyMenuDelegate {
    
    @IBOutlet weak var patientNameTextField: CustomTextField!
    @IBOutlet weak var patientPhoneNumberTextField: CustomTextField!
    @IBOutlet weak var clinicMenu: SwiftyMenu!
    @IBOutlet weak var diseaseTextField: CustomTextField!
    @IBOutlet weak var priceTextField: CustomTextField!
    @IBOutlet weak var alergyTextField: CustomTextField!
    @IBOutlet weak var noAlergyButton: CheckButton!
    @IBOutlet weak var hasAlergyButton: CheckButton!
    @IBOutlet weak var dateTextField: CustomTextField!
    @IBOutlet weak var notesTextView: CustomTextView!
    @IBOutlet weak var wordLimitLabel: UILabel!
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    @IBOutlet weak var addImageButton: UIButton!
    @IBOutlet weak var addImageLabel: UIButton!
    @IBOutlet weak var submitButton: CustomButton!
    @IBOutlet weak var errorView: CustomUIView!
    @IBOutlet weak var diseaseTextFieldTopAnchor: NSLayoutConstraint!
    
    var clinicOptions = [String]()
    let datePicker = UIDatePicker()
    var textViewDelegate: TextViewDelegate?
    var imagePickerDelegate: ImagePickerDelegate?
    var imageCollectionViewDelegate: ImagesCollectionViewDelegate?
    
    var textFields = [CustomTextField]()
    var currentTextField: UITextField?
    var appointmentData = ["", "", "", -1, "", ""] as [Any] //0: name, 1: phone, 2: disease, 3: price, 4: alergy, 5: notes
    var clinicTitle: String?
    var hasAlergy: Bool = false
    var date: Date?
    
    let appointmentID = UUID()
    
    //MARK: Clinic Functions
    func prepareClinicMenu() {
        getClinics()
        if clinicOptions.count > 0 {
            setClinicMenuDelegates()
        } else {
            hideClinicMenu()
        }
    }
    
    func getClinics() {
        clinicOptions.removeAll()
        if let clinics = Info.dataController.fetchAllClinics() as? [Clinic] {
            for clinic in clinics {
                clinicOptions.append(clinic.title)
            }
        }
    }
    
    func hideClinicMenu() {
        clinicMenu.isHidden = true
        diseaseTextFieldTopAnchor.constant = -54
    }
    
    func setClinicMenuDelegates() {
        clinicMenu.isHidden = false
        diseaseTextFieldTopAnchor.constant = 16
        
        clinicMenu.delegate = self
        clinicMenu.options = clinicOptions
        clinicMenu.collapsingAnimationStyle = .spring(level: .low)
    }
    
    func didSelectOption(_ swiftyMenu: SwiftyMenu, _ selectedOption: SwiftMenuDisplayable, _ index: Int) {
        clinicTitle = selectedOption.displayValue
    }
    
    //MARK: DatePicker Functions
    func creatDatePicker() {
        datePicker.createPersianDatePicker(mode: .dateAndTime)
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
    
    //MARK: Alergy Buttons Functions
    @IBAction func checkAlergySelected(_ sender: Any) {
        if let button = sender as? CheckButton {
            setHasAlergy(by: button)
            button.visibleSelection()
        }
    }
    
    func setHasAlergy(by button: CheckButton) {
        hasAlergy = button.hasAlergy()
        alergyTextField.isEnabled = hasAlergy
    }
    
    //MARK: TextFields Functions
    @IBAction func editingStarted(_ sender: Any) {
        if let textField = sender as? UITextField {
            currentTextField = textField
//            if textField.tag == 3 {
//                textField.text = nil
//            }
        }
    }
    
    @IBAction func editingEnded(_ sender: Any) {
        if let textField = sender as? UITextField, let text = textField.fetchInput() {
            if textField.tag == 3 {
                if let price = Int(text) {
                    appointmentData[textField.tag] = price
                    textField.text = "\(String.toPersianPriceString(price: price)) تومان"
                }
            } else {
                appointmentData[textField.tag] = text
            }
        } else if let textView = sender as? UITextView, let text = textView.fetchInput() {
            appointmentData[textView.tag] = text
        }
    }
    
    //MARK: Keboard Management
    @IBAction func next(_ sender: Any) {
        if let textField = sender as? UITextField {
            textFields[textField.tag + 1].becomeFirstResponder()
        }
    }
    
    @IBAction func hideKeyboard(_ sender: Any) {
        if let textField = currentTextField {
            textField.resignFirstResponder()
        } else {
            notesTextView.resignFirstResponder() //TODO: bug
        }
    }
    
    //MARK: Image Picking
    @IBAction func addPhoto(_ sender: Any) {
        imagePickerDelegate?.displayImagePickingOptions()
    }
    
    func showButtons() {
        addImageButton.isHidden = false
        addImageLabel.isHidden = false
    }
    
    func hideButtons() {
        addImageButton.isHidden = true
        addImageLabel.isHidden = true
    }
    
    //MARK: Submission
    @available(iOS 13.0, *)
    @IBAction func submit(_ sender: Any) {
        editingEnded(currentTextField as Any)
        currentTextField = nil
        editingEnded(notesTextView as Any)
        
        if let requiredItem = mustComplete() {
            submitionError(for: requiredItem)
            return
        }
        
        let appointment = Appointment.createAppointment(id: appointmentID, name: appointmentData[0] as! String, phone: appointmentData[1] as! String, diseaseTitle: appointmentData[2] as! String, price: appointmentData[3] as! Int, clinicTitle: clinicTitle, alergies: appointmentData[4] as? String, visit_time: date!, notes: appointmentData[5] as? String)
        Info.sharedInstance.sync()
        RestAPIManagr.sharedInstance.addAppointment(appointment: appointment)
//        Info.dataController.loadData()
        
        back()
    }
    
    func mustComplete() -> Any? {
        for i in 0 ..< 3 {
            if appointmentData[i] as? String == "" {
                return textFields[i]
            }
        }
        if clinicOptions.count > 0 && clinicTitle == nil {
            return clinicMenu
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
    
    func submitionError(for requiredItem: Any) {
        if let textField = requiredItem as? CustomTextField {
            textField.showError()
        }
        else if let menu = requiredItem as? SwiftyMenu {
            menu.showError()
        }
        self.showToast(message: "خطا: همه‌ی موارد ضروری وارد نشده است.")
    }
    
    //MARK: Exit
    @IBAction func returnBack(_ sender: Any) {
        back()
    }
    
    func back() {
        tabBarController?.selectedViewController = Info.sharedInstance.lastViewController
    }
    
    //MARK: UI Handling
    func setUIComponents() {
        self.tabBarController?.tabBar.isHidden = true
        notesTextView.textColor = Color.gray.componentColor
    }
    
    //MARK: Initialization
    func setImagesDelegates() {
        imageCollectionViewDelegate = ImagesCollectionViewDelegate(imagesCollectionView:imagesCollectionView, viewController: self)
        imagesCollectionView.delegate = imageCollectionViewDelegate
        imagesCollectionView.dataSource = imageCollectionViewDelegate
        imagePickerDelegate = ImagePickerDelegate(from: self, imagesCollectionViewDelegate: imageCollectionViewDelegate!)
    }
    
    func setNotesDelegates() {
        textViewDelegate = TextViewDelegate(label: wordLimitLabel)
        notesTextView.delegate = textViewDelegate
    }
    
    func setDelegates() {
        prepareClinicMenu()
        setImagesDelegates()
        setNotesDelegates()
    }
    
    func configure() {
        setUIComponents()
        creatDatePicker()
        setDelegates()
        textFields = [patientNameTextField, patientPhoneNumberTextField, diseaseTextField, priceTextField, alergyTextField, dateTextField]
    }
    
    override func viewWillLayoutSubviews() {
        configure()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
//    override func viewWillLayoutSubviews() {
//        configure()
//    }
}

//alergy typed then canceled?
//hiding keyboard
