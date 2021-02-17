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
        configure()
    }
    
    private func configure() {
        selectTabBarItem()
        setUIComponents()
    }
    
    private func selectTabBarItem() {
        if Info.sharedInstance.isForReturn,
            let lastViewController = Info.sharedInstance.lastViewControllerIndex {
            Info.sharedInstance.isForReturn = false
            tabBarController?.selectedIndex = lastViewController
        }
    }
    
    private func setUIComponents() {
        navigationController?.setNavigationBarHidden(true, animated: true)
        navigationController?.navigationBar.prefersLargeTitles = false
        tabBarController?.tabBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        setLastViewController()
    }
    
    private func setLastViewController() {
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
}
