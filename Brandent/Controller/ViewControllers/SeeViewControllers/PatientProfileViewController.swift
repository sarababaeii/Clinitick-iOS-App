//
//  PatientProfileViewController.swift
//  Brandent
//
//  Created by Sara Babaei on 11/3/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//

import Foundation
import UIKit
import SwiftyMenu

class PatientProfileViewController: FormViewController {
    
    @IBOutlet weak var phoneTextField: CustomTextField!
    @IBOutlet weak var nameTextField: CustomTextField!
    @IBOutlet weak var clinicsTextField: CustomTextField!
    @IBOutlet weak var alergyMenu: SwiftyMenu!
    @IBOutlet weak var appointmentsTableView: UITableView!
    
    var patient: Patient?
    
    var selectedEditButton: UIButton?
    var textFieldDelegates = [TextFieldDelegate]()
//    var menuDelegate: MenuDelegate?
    var appointmentsTableViewDelegate: AppointmentsTableViewDelegate?
    
    //MARK: Initialization
    override func viewDidLoad() {
        configure()
    }
    
    func configure() {
        guard let patient = patient else {
            return
        }
        initializeTextFields()
//        setMenuDelegate()
        setInformation()
        setTitle(title: patient.name)
        setTableViewDelegates()
    }
    
    func initializeTextFields() {
        textFields = [phoneTextField, nameTextField]
        data = [patient!.phone, patient!.name, patient!.alergies ?? ""] //0: phone, 1: name, 2: alergy
        setTextFieldDelegates()
    }
    
    func setTextFieldDelegates() {
        textFieldDelegates = [
            TextFieldDelegate(viewController: self, isForPrice: false, isForDate: false),
            TextFieldDelegate(viewController: self, isForPrice: false, isForDate: false)]
        for i in 0 ..< 2 {
            textFields[i].delegate = textFieldDelegates[i]
        }
    }
    
    //MARK: Set Information
    func setInformation() {
        phoneTextField.text = patient?.phone
        nameTextField.text = patient?.name
        setClinics()
        //set alergy
    }
    
    func setClinics() {
        guard let clinics = patient?.getClinics() else {
            return
        }
        clinicsTextField.text = getClinicsString(clinics: clinics)
//        menuDelegate = MenuDelegate(viewController: self, menuDataIndex: 2)
//        menuDelegate!.prepareClinicMenu(menu: clinicMenu)
    }
    
    func getClinicsString(clinics: [Clinic]) -> String {
        var str = ""
        for clinic in clinics {
            if str != "" {
                str += "، "
            }
            str += clinic.title
        }
        return str
    }
    
    func setTableViewDelegates() {
        appointmentsTableViewDelegate = AppointmentsTableViewDelegate(viewController: self, tableView: appointmentsTableView, patient: patient!)
        appointmentsTableView.delegate = appointmentsTableViewDelegate
        appointmentsTableView.dataSource = appointmentsTableViewDelegate
    }
    
    //MARK: Editing
    @IBAction func editPatientData(_ sender: Any) {
        guard let button = sender as? UIButton, let title = button.titleLabel?.text else {
            return
        }
        if title == "ویرایش" {
            selectedEditButton = button
            textFields[button.tag].isEnabled = true
            button.setTitle("ثبت", for: .normal)
        } else {
            submitForm()
        }
    }
    
    override func mustComplete() -> Any? {
        for i in 0 ..< 2 {
            if data[i] as? String == "" {
                return textFields[i]
            }
        }
        return nil
    }
    
    override func saveData() {
        patient?.updatePatient(phone: data[0] as? String, name: data[1] as? String, alergies: data[2] as? String, isDeleted: nil, modifiedTime: Date())
        if let button = selectedEditButton {
            textFields[button.tag].isEnabled = false
            button.setTitle("ویرایش", for: .normal)
        }
    }
    
    override func back() {
    }
    
    //MARK: Sending Data With Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditAppointmentFromPatientSegue",
            let cell = sender as? AppointmentTableViewCell,
            let appointment = cell.appointment,
            let viewController = segue.destination as? TempAddAppointmrntViewController {
                viewController.appointment = appointment
        }
        if segue.identifier == "GallerySegue",
            let viewController = segue.destination as? GalleryViewController,
            let patient = patient {
            viewController.patient = patient
        }
    }
}
