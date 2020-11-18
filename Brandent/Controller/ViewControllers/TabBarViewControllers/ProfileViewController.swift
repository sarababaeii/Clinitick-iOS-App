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

    func checkParent() {
        guard let item = Info.sharedInstance.selectedMenuItem else {
            return
        }
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: item.viewControllerIdentifier) as UIViewController
        navigationController?.show(controller, sender: nil)
        Info.sharedInstance.selectedMenuItem = nil
    }
    
    func configure() {
        checkParent()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Info.sharedInstance.lastViewControllerIndex = TabBarItemIndex.profile.rawValue
        configure()
//        print(Info.sharedInstance.defaults.string(forKey: Info.sharedInstance.lastUpdatedDefaultsKey))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}
