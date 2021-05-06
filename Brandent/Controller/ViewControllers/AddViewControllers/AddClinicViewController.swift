//
//  AddClinicViewController.swift
//  Brandent
//
//  Created by Sara Babaei on 10/30/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//

import Foundation
import UIKit

class AddClinicViewController: FormViewController {
    
    @IBOutlet weak var titleTextField: CustomTextField!
    @IBOutlet weak var addressTextField: CustomTextField!
    @IBOutlet weak var colorsCollectionView: UICollectionView!
    
    var textFieldDelegates = [TextFieldDelegate]()
    var colorsCollectionViewDelegate: ColorsCollectionViewDelegate?
    var defaultColor = Color.lightGreen
    
    var clinic: Clinic?
    
    //MARK: Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    func configure() {
        initializeTextFields()
        setColorsDelegate()
        setTitle(title: "افزودن مطب")
    }
    
    func initializeTextFields() {
        textFields = [titleTextField, addressTextField]
        data = ["", ""] //0: title, 1: address
        setTextFieldDelegates()
        setTextFieldsData()
    }
    
    func setTextFieldsData() {
        if let clinic = clinic {
            titleTextField.text = clinic.title
            addressTextField.text = clinic.address
            defaultColor = Color.getColor(description: clinic.color)
            data = [clinic.title, clinic.address as Any]
        }
    }
    
    func setTextFieldDelegates() {
        textFieldDelegates = [TextFieldDelegate(viewController: self, isForPrice: false, isForDate: false), TextFieldDelegate(viewController: self, isForPrice: false, isForDate: false)]
        for i in 0 ..< 2 {
            textFields[i].delegate = textFieldDelegates[i]
        }
    }
    
    func setColorsDelegate() {
        let colors = [Color.lightGreen, Color.darkGreen, Color.indigo, Color.lightBlue, Color.darkBlue, Color.purple, Color.pink, Color.red]
        colorsCollectionViewDelegate = ColorsCollectionViewDelegate(colors: colors, selectedColor: defaultColor)
        colorsCollectionView.delegate = colorsCollectionViewDelegate
        colorsCollectionView.dataSource = colorsCollectionViewDelegate
    }
    
    //MARK: User Flow
    @IBAction func hideKeyboard(_ sender: Any) {
        if let textField = currentTextField {
            textField.resignFirstResponder()
        }
    }
    
    //MARK: Submission
    @IBAction func submit(_ sender: Any) {
        submitForm()
    }
    
    override func mustComplete() -> Any? {
        if data[0] as? String == "" {
            return textFields[0]
        }
        return nil
    }
    
    override func saveData() {
        let color = colorsCollectionViewDelegate?.selectedColorCell?.color ?? Color.lightGreen
        let _ = Clinic.getClinic(id: self.clinic?.id, title: (data[0] as? String)!, address: data[1] as? String, color: color.clinicColorDescription, isDeleted: nil, modifiedTime: Date())
        Info.sharedInstance.sync()
    }
}
