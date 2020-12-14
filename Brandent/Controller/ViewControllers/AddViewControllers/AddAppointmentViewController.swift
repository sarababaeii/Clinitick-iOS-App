//
//  AddViewController.swift
//  Brandent
//
//  Created by Sara Babaei on 9/14/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//

import Foundation
import UIKit

class AddAppointmentViewController: UITableViewController {
    
    var patient: Patient?
    
    //MARK: UI Management
    func setTitle() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "فعالیت درمانی", style: UIBarButtonItem.Style.plain, target: self, action: .none)
        self.navigationItem.rightBarButtonItem?.setTitleTextAttributes([ NSAttributedString.Key.font: UIFont(name: "Vazir-Bold", size: 22.0)!], for: .normal)
    }
    
    func configure() {
        setTitle()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    //MARK: Showing NavigationBar
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}
