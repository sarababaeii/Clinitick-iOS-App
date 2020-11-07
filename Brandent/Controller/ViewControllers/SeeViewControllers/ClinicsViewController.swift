//
//  ClinicsViewController.swift
//  Brandent
//
//  Created by Sara Babaei on 10/30/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//

import Foundation
import UIKit

@available(iOS 13.0, *)
class ClinicsViewController: UIViewController {
    
    @IBOutlet weak var clinicsTableView: UITableView!
    
    var clinicsTableViewDelegate: ClinicsTableViewDelegate?
    
    func setDelegates() {
        clinicsTableViewDelegate = ClinicsTableViewDelegate()
        clinicsTableView.delegate = clinicsTableViewDelegate
        clinicsTableView.dataSource = clinicsTableViewDelegate
    }
    
    func configure() {
        setDelegates()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        configure()
    }
}
