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
    
    @IBOutlet weak var dentistProfileView: CustomImageView!
    @IBOutlet weak var dentistImageView: CustomImageView!
    @IBOutlet weak var addImageButton: UIButton!
    @IBOutlet weak var dentistNameLabel: UILabel!
    @IBOutlet weak var specialityLabel: UILabel!
    
    var imagePickerDelegate: ProfileImagePickerDelegate?
    
    //MARK: Initialization
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configure()
    }
    
    func configure() {
        setDelegates()
        setDentistInformation()
    }
    
    func setDelegates() {
        DispatchQueue.main.async {
            self.imagePickerDelegate = ProfileImagePickerDelegate(from: self)
        }
    }
    
    func setDentistInformation() {
        guard let dentist = Info.sharedInstance.dentist else {
            return
        }
        if let image = dentist.photo {
            setDentistProfile(image: UIImage(data: image))
        } else {
            addImageButton.isHidden = false
        }
        dentistNameLabel.text = dentist.first_name + " " + dentist.last_name
        specialityLabel.text = dentist.speciality
    }
    
    func setDentistProfile(image: UIImage?) {
        guard let image = image else {
            return
        }
        dentistProfileView.backgroundColor = UIColor(patternImage: image)
        dentistProfileView.applyBlurEffect()
        dentistImageView.image = image
        addImageButton.setImage(nil, for: .normal)
    }
    
    @IBAction func changeProfileImage(_ sender: Any) {
        imagePickerDelegate?.displayImagePickingOptions()
    }
    
    @IBAction func logOut(_ sender: Any) {
        Info.sharedInstance.token = nil
        Info.sharedInstance.dentistID = nil
        nextPage()
    }
    
    func nextPage() {
        guard let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController else {
            return
        }
        navigationController?.show(controller, sender: nil)
    }
}
