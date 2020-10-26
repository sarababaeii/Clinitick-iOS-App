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

class AddViewController: UIViewController, UITextViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var patientNameTextField: CustomTextField!
    @IBOutlet weak var patientPhoneNumberTextField: CustomTextField!
    @IBOutlet weak var diseaseTextField: CustomTextField!
    @IBOutlet weak var priceTextField: CustomTextField!
    @IBOutlet weak var alergyTextField: CustomTextField!
    @IBOutlet weak var noAlergyButton: CheckButton!
    @IBOutlet weak var hasAlergyButton: CheckButton!
    @IBOutlet weak var dateTextField: CustomTextField!
    @IBOutlet weak var notesTextView: CustomTextView!
    @IBOutlet weak var wordLimitLabel: UILabel!
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    @IBOutlet weak var submitButton: CustomButton!
    @IBOutlet weak var errorView: CustomUIView!
    
    let datePicker = UIDatePicker()
    var textViewDelegate: TextViewDelegate?
    var imagePickerDelegate: ImagePickerDelegate?
    var textFields = [UITextField]()
    var currentTextField: UITextField?
    
    var hasAlergy: Bool = false
    var date: Date?
    var appointmentData = ["", "", "", -1, "", ""] as [Any] //0: name, 1: phone, 2: disease, 3: price, 4: alergy, 5: notes
    
    //MARK: DatePicker Functions
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
    
    
    
    var images = [UIImage(named: "profile"), UIImage(named: "white_tick"), UIImage(named: "diseases")]
    
    //MARK: Protocol Functions
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("Count: \(images.count)")
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCellID", for: indexPath) as! ImageCollectionViewCell
        
        print("Cell generated for \(indexPath.row), \(indexPath.item)")
        if let image = imageDataSource(indexPath: indexPath) {
            cell.setAttributes(image: image)
        }
        return cell
    }
    
    func imageDataSource(indexPath: IndexPath) -> UIImage? {
        print("Wants image in \(indexPath.row)")
        if indexPath.row < images.count {
            return images[indexPath.row]
        }
        return nil
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
        editingEnded(notesTextView as Any)
        
        if let requiredTextField = mustComplete() {
            submitionError(for: requiredTextField)
            return
        }
        
        let appointment = Appointment.createAppointment(name: appointmentData[0] as! String, phone: appointmentData[1] as! String, diseaseTitle: appointmentData[2] as! String, price: appointmentData[3] as! Int, alergies: appointmentData[4] as? String, visit_time: date!, notes: appointmentData[5] as? String)
        RestAPIManagr.sharedInstance.addAppointment(appointment: appointment)
        Info.dataController.loadData()
        
        back()
    }
    
    func submitionError(for textField: CustomTextField) {
        if textField.placeHolderColor != Color.red.componentColor {
            textField.placeholder = "*\(textField.placeholder!)"
            textField.placeHolderColor = Color.red.componentColor
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
    
    //MARK: Initialization
    func setDelegates() {
        imagePickerDelegate = ImagePickerDelegate(from: self)
        
        let imageCollectionViewDelegate = ImageCollectionViewDelegate(imagesCollectionView: imagesCollectionView)
        imagesCollectionView.delegate = self
        imagesCollectionView.dataSource = self
        print("Delegates sat")
        
        textViewDelegate = TextViewDelegate(label: wordLimitLabel)
        notesTextView.delegate = textViewDelegate
    }
    
    func configure() {
        notesTextView.textColor = Color.gray.componentColor
        creatDatePicker()
        setDelegates()
        textFields = [patientNameTextField, patientPhoneNumberTextField, diseaseTextField, priceTextField, alergyTextField, dateTextField]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        configure()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        configure()
    }
}


//TODO: get images

//alergy typed then canceled?

//TODO: iOS availability
