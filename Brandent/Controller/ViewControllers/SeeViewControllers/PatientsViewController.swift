//
//  PatientsViewController.swift
//  Brandent
//
//  Created by Sara Babaei on 10/28/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//

import Foundation
import UIKit

@available(iOS 13.0, *)
class PatientsViewController: UIViewController {
    
    @IBOutlet weak var patientsTableView: UITableView!
    
    var patientsTableViewDelegate: PatientsTableViewDelegate?
    
    let testPatients = [Patient]()
    
    func setDelegates() {
        patientsTableViewDelegate = PatientsTableViewDelegate()
        patientsTableView.delegate = patientsTableViewDelegate
        patientsTableView.dataSource = patientsTableViewDelegate
    }
    
    func configure() {
//        Info.sharedInstance.lastViewController = self
        setDelegates()
    }
    
    override func viewDidLoad() {
        configure()
    }
}
