//
//  ProfileViewController.swift
//  Brandent
//
//  Created by Sara Babaei on 9/14/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//

import Foundation
import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var dentistImageView: CustomImageView!
    @IBOutlet weak var dentistNameLabel: UILabel!
    @IBOutlet weak var specialityLabel: UILabel!
    
    func setDentistInformation() {
        guard let dentist = Info.sharedInstance.dentist else {
            return
        }
//        dentistImageView.image = dentist.photo
        dentistNameLabel.text = dentist.first_name + dentist.last_name
        specialityLabel.text = dentist.speciality
    }
    
    func configure() {
        setDentistInformation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Info.sharedInstance.lastViewControllerIndex = TabBarItemIndex.profile.rawValue
    }
    
    //MARK: Hiding NavigationBar
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
}
