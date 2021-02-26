//
//  ClinicMenuDelegate.swift
//  Brandent
//
//  Created by Sara Babaei on 12/18/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//

import Foundation

class MenuDelegate: NSObject, SwiftyMenuDelegate {
    
    var viewController: FormViewController
    var menuDataIndex: Int
    
    init(viewController: FormViewController, menuDataIndex: Int) {
        self.viewController = viewController
        self.menuDataIndex = menuDataIndex
    }
    
    func setMenuDelegates(menu: SwiftyMenu, options: [String]) {
//        menu.isHidden = false
        menu.delegate = self
        menu.options = options
        menu.collapsingAnimationStyle = .spring(level: .low)
    }
    
    //MARK: Clinic Functions
    func prepareClinicMenu(menu: SwiftyMenu) {
        let options = getClinics()
        if options.count > 0 {
            setMenuDelegates(menu: menu, options: options)
        }
    }
        
    private func getClinics() -> [String]{
        var options = [String]()
        if let clinics = DataController.sharedInstance.fetchAllClinics() as? [Clinic] {
            for clinic in clinics {
                options.append(clinic.title)
            }
        }
        return options
    }
    
    //MARK: Delegate Function
    func didSelectOption(_ swiftyMenu: SwiftyMenu, _ selectedOption: SwiftMenuDisplayable, _ index: Int) {
        viewController.data[menuDataIndex] = selectedOption.displayValue
    }
}
