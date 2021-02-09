//
//  TabBarViewController.swift
//  Brandent
//
//  Created by Sara Babaei on 1/14/21.
//  Copyright © 2021 Sara Babaei. All rights reserved.
//

import Foundation
import UIKit

class TabBarViewController: UIViewController {
    
    //MARK: Hiding NavigationBar
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        setLastViewController()
//        configure()
    }
    
    private func setLastViewController() {
        print("VC is: \(self.restorationIdentifier)")
        switch self.restorationIdentifier {
        case "HomeViewController":
            Info.sharedInstance.lastViewControllerIndex = TabBarItemIndex.home.rawValue
        case "FinanceViewController":
            Info.sharedInstance.lastViewControllerIndex = TabBarItemIndex.finance.rawValue
        case "TasksViewController":
            Info.sharedInstance.lastViewControllerIndex = TabBarItemIndex.tasks.rawValue
        case "ProfileViewController":
            Info.sharedInstance.lastViewControllerIndex = TabBarItemIndex.profile.rawValue
        default:
            Info.sharedInstance.lastViewControllerIndex = TabBarItemIndex.home.rawValue
        }
    }
    
//    func configure() {
//    }
}
