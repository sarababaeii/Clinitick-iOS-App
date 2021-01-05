//
//  NavigationBarViewController.swift
//  Brandent
//
//  Created by Sara Babaei on 1/2/21.
//  Copyright © 2021 Sara Babaei. All rights reserved.
//

import Foundation
import UIKit

class NavigationBarViewController: UIViewController {
    
    //MARK: Initialization
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    //MARK: Title
    func setTitle(title: String) {
        let navigationItem = getNavigationItem()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: title, style: UIBarButtonItem.Style.plain, target: self, action: .none)
        navigationItem.rightBarButtonItem?.setTitleTextAttributes([ NSAttributedString.Key.font: UIFont(name: "Vazir-Bold", size: 22.0)!], for: .normal)
    }
    
    private func getNavigationItem() -> UINavigationItem {
        if let tabBarController = self.tabBarController {
            return tabBarController.navigationItem
        }
        return self.navigationItem
    }
    
    //MARK: Navigation
    func navigateToPage(identifier: String) {
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: identifier)
        navigationController?.show(controller, sender: nil)
    }
}
