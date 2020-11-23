//
//  AddClinicViewController.swift
//  Brandent
//
//  Created by Sara Babaei on 10/30/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//

import Foundation
import UIKit

class AddClinicViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: CustomTextField!
    @IBOutlet weak var addressTextField: CustomTextField!
    @IBOutlet weak var colorsCollectionView: UICollectionView!
    
    var textFields = [CustomTextField]()
    var currentTextField: UITextField?
    var colorsCollectionViewDelegate: ColorsCollectionViewDelegate?
    
    var clinicData = ["", ""] //0: title, 1: address
    
    @IBAction func editingStarted(_ sender: Any) {
        if let textField = sender as? UITextField {
            currentTextField = textField
        }
    }
    
    @IBAction func editingEnded(_ sender: Any) {
        if let textField = sender as? UITextField, let text = textField.fetchInput() {
            clinicData[textField.tag] = text
        }
    }
    
    @IBAction func next(_ sender: Any) {
        if let textField = sender as? UITextField {
            textFields[textField.tag + 1].becomeFirstResponder()
        }
    }
    
    @IBAction func hideKeyboard(_ sender: Any) {
        if let textField = currentTextField {
            textField.resignFirstResponder()
        }
    }
    
    //MARK: Submission
    func mustComplete() -> CustomTextField? {
        if clinicData[0] == "" {
            return textFields[0]
        }
        return nil
    }
    
    func submitionError(for textField: CustomTextField) {
        if textField.placeHolderColor != Color.red.componentColor {
            textField.placeholder = "*\(textField.placeholder!)"
            textField.placeHolderColor = Color.red.componentColor
        }
        self.showToast(message: "خطا: همه‌ی موارد ضروری وارد نشده است.")
    }
    
    @available(iOS 13.0, *)
    @IBAction func submit(_ sender: Any) {
        editingEnded(currentTextField as Any)
        currentTextField = nil
        
        if let requiredTextField = mustComplete() {
            submitionError(for: requiredTextField)
            return
        }
        let color = colorsCollectionViewDelegate?.selectedColorCell?.color ?? Color.lightGreen
        let clinic = Clinic.getClinic(id: nil, title: clinicData[0], address: clinicData[1], color: color.clinicColor.toHexString())
        RestAPIManagr.sharedInstance.addClinic(clinic: clinic)
        
        back()
    }
    
    func back() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setDelegates() {
        let colors = [Color.lightGreen, Color.darkGreen, Color.indigo, Color.lightBlue, Color.darkBlue, Color.purple, Color.pink, Color.red]
        colorsCollectionViewDelegate = ColorsCollectionViewDelegate(colors: colors)
        colorsCollectionView.delegate = colorsCollectionViewDelegate
        colorsCollectionView.dataSource = colorsCollectionViewDelegate
    }
    
    func configure() {
        textFields = [titleTextField, addressTextField]
        setDelegates()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "افزودن مطب", style: UIBarButtonItem.Style.plain, target: self, action: .none)
        self.navigationItem.rightBarButtonItem?.setTitleTextAttributes([ NSAttributedString.Key.font: UIFont(name: "Vazir-Bold", size: 26.0)!], for: .normal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configure()
    }
}
