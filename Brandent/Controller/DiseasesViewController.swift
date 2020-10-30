//
//  DiseasesViewController.swift
//  Brandent
//
//  Created by Sara Babaei on 10/28/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//

import Foundation
import UIKit

@available(iOS 13.0, *)
class DiseaseViewController: UIViewController {
   
    @IBOutlet weak var diseasesTableView: UITableView!
    
    var diseasesTableViewDelegate: DiseasesTableViewDelegate?
    
    let array = [1, 2, 3]
    
    func setDelegates() {
        diseasesTableViewDelegate = DiseasesTableViewDelegate()
        diseasesTableView.delegate = diseasesTableViewDelegate
        diseasesTableView.dataSource = diseasesTableViewDelegate
    }
    
    func configure() {
        setDelegates()
    }
    
    override func viewDidLoad() {
        configure()
    }
}
