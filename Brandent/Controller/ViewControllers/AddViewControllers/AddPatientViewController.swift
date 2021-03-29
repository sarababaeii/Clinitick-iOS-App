//
//  AddPatientViewController.swift
//  Brandent
//
//  Created by Sara Babaei on 12/13/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//

import Foundation
import UIKit

class AddPatientViewController: FormViewController {
    
    @IBOutlet weak var phoneNumberTextField: CustomTextField!
    @IBOutlet weak var nameTextField: CustomTextField!
    @IBOutlet weak var clinicMenu: SwiftyMenu!
    @IBOutlet weak var allergyMenu: SwiftyMenu!
    
    var textFieldDelegates = [TextFieldDelegate]()
    var clinicMenuDelegate: ClinicMenuDelegate?
    var allergyMenuDelegate: AllergyMenuDelegate?
    
    var patient: Patient?
    
    //MARK: Initialization
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        configure()
    }
    
    func configure() {
        setMenuDelegate()
        initializeTextFields()
        
        setTitle(title: "اطلاعات بیمار")
        setBackButton()
    }
    
    func initializeTextFields() {
        textFields = [phoneNumberTextField, nameTextField]
        emptyTextFields()
        setTextFieldDelegates()
    }
    
    func emptyTextFields() {
        if !Info.sharedInstance.isForReturn {
            patient = nil
            data = ["", "", "", ""] //0: phone, 1: name, 2: clinic, 3: alergy
            for i in 0 ..< 2 {
                textFields[i].text = ""
                textFields[i].removeError()
            }
            clinicMenu.selectedIndex = nil
            clinicMenu.selectOption(index: 0)
            initializeAllergies()
            allergyMenu.unselectOptions()
        }
    }
    
    func setTextFieldDelegates() {
        textFieldDelegates = [
            TextFieldDelegate(viewController: self, isForPrice: false, isForDate: false),
            TextFieldDelegate(viewController: self, isForPrice: false, isForDate: false)]
        for i in 0 ..< 2 {
            textFields[i].delegate = textFieldDelegates[i]
        }
    }
    
    func setMenuDelegate() {
        setClinicMenuDelegate()
        setAllergyMenuDelegate()
    }
    
    func setClinicMenuDelegate() {
        clinicMenuDelegate = ClinicMenuDelegate(viewController: self, menuDataIndex: 2)
        clinicMenuDelegate!.prepareMenu(menu: clinicMenu)
    }
    
    func setAllergyMenuDelegate() {
        allergyMenuDelegate = AllergyMenuDelegate(viewController: self, menuDataIndex: 3)
        allergyMenuDelegate!.prepareMenu(menu: allergyMenu)
    }
    
    func setBackButton() {
        self.tabBarController?.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "بازگشت", style: UIBarButtonItem.Style.plain, target: self, action: #selector(back))
        navigationItem.rightBarButtonItem?.setTitleTextAttributes([ NSAttributedString.Key.font: UIFont(name: "Vazir-Bold", size: 14.0)!], for: .normal)
    }
    
    @objc override func back() {
        if let lastViewController = Info.sharedInstance.lastViewControllerIndex {
            tabBarController?.selectedIndex = lastViewController
        }
    }
    
    //MARK: Keyboard Management
    @IBAction func hideKeyboard(_ sender: Any) {
        if let textField = currentTextField {
            textField.resignFirstResponder()
        }
    }
    
    @IBAction func editingDidEnd(_ sender: Any) {
        guard let textField = sender as? UITextField, let phone = textField.fetchInput() else {
            return
        }
        autoFillData(phone: phone)
    }
    
    
    func autoFillData(phone: String) {
        guard let patient = Patient.getPatientByPhone(phone) else {
            return
        }
        nameTextField.text = patient.name
        if let alergies = patient.alergies {
            allergyMenu.selectOptions(options: alergies)
        }
    }
    
    //MARK: Submission
    @IBAction func submit(_ sender: Any) {
        savePatient(isForGallery: false)
        if let clinic = getClinic(), let patient = patient {
            nextPage(patient: patient, clinic: clinic)
        }
    }
    
    func mustComplete(isForGallery: Bool) -> Any? {
        for i in 0 ..< 3 { //alergy is optional
            if data[i] as? String == "" {
                if i == 2 && !isForGallery {
                    return clinicMenu
                }
                if i != 2 {
                    return textFields[i]
                }
            }
        }
        return nil
    }
    
    func savePatient(isForGallery: Bool) {
        getLastData()
        if let requiredItem = mustComplete(isForGallery: isForGallery) {
            submitionError(for: requiredItem)
            return
        }
        patient = Patient.getPatient(id: nil, phone: data[0] as! String, name: data[1] as! String, alergies: (data[3] as! String), isDeleted: nil, modifiedTime: Date())
    }
    
    func getClinic() -> Clinic? {
        return Clinic.getClinicByTitle(data[2] as! String)
    }
    
    //MARK: Navigation Management
    @IBAction func showGallery(_ sender: Any) {
        savePatient(isForGallery: true)
        Info.sharedInstance.sync()
        guard let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GalleryViewController") as? GalleryViewController, let patient = patient else {
            return
        }
        controller.patient = patient
        navigationController?.show(controller, sender: nil)
    }
    
    func nextPage(patient: Patient, clinic: Clinic) {
        guard let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddAppointmentViewController") as? AddAppointmentViewController else {
            return
        }
        controller.patient = patient
        controller.clinic = clinic
        navigationController?.show(controller, sender: nil)
    }
}
