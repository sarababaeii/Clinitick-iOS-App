//
//  ProfileViewController.swift
//  Brandent
//
//  Created by Sara Babaei on 9/14/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//

import Foundation
import UIKit

class ProfileViewController: TabBarViewController {
    
    @IBOutlet weak var dentistImageView: CustomImageView!
    @IBOutlet weak var dentistNameLabel: UILabel!
    @IBOutlet weak var specialityLabel: UILabel!
    
    var imagePickerDelegate: ProfileImagePickerDelegate?
    
    //MARK: Initialization
    override func viewDidAppear(_ animated: Bool) {
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setDentistInformation()
    }
    
    func configure() {
        setDelegates()
//        setDentistInformation()
    }
    
    func setDelegates() {
        imagePickerDelegate = ProfileImagePickerDelegate(from: self)
    }
    
    func setDentistInformation() {
        guard let dentist = Info.sharedInstance.dentist else {
            return
        }
        dentistImageView.image = UIImage(data: dentist.photo!)
        dentistNameLabel.text = dentist.first_name + " " + dentist.last_name
        specialityLabel.text = dentist.speciality
    }
    
    @IBAction func changeProfileImage(_ sender: Any) {
        imagePickerDelegate?.displayImagePickingOptions()
    }
    
    @IBAction func logOut(_ sender: Any) {
        Info.sharedInstance.token = nil
        Info.sharedInstance.dentistID = nil //TODO: Check
        nextPage()
    }
    
    func nextPage() {
        guard let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController else {
            return
        }
        navigationController?.show(controller, sender: nil)
    }
}
