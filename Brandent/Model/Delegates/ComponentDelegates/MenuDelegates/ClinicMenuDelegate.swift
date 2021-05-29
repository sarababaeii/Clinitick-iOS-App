//
//  ClinicMenuDelegate.swift
//  Brandent
//
//  Created by Sara Babaei on 3/7/21.
//  Copyright © 2021 Sara Babaei. All rights reserved.
//

import Foundation

class ClinicMenuDelegate: MenuDelegate {
    
    var isEmpty = false
    
    init(viewController: FormViewController, menuDataIndex: Int) {
        super.init(viewController: viewController, menuDataIndex: menuDataIndex)
    }
    
    //MARK: Collecting Options
    override func prepareMenu(menu: SwiftyMenu) {
        let options = getClinics()
        if options.count > 0 {
            setMenuDelegates(menu: menu, options: options)
        }
        isEmpty = !(options.count > 0)
    }
        
    private func getClinics() -> [String]{
        var options = [String]()
        if let clinics = Info.sharedInstance.dataController?.fetchAllClinics() as? [Clinic] {
            for clinic in clinics {
                options.append(clinic.title)
            }
        }
        return options
    }
    
    //MARK: Delegate Function
    override func didSelectOption(_ swiftyMenu: SwiftyMenu, _ selectedOption: SwiftMenuDisplayable, _ index: Int) {
        guard let viewController = viewController as? FormViewController else {
            return
        }
        viewController.data[menuDataIndex] = selectedOption.displayValue
    }
    
    override func didUnselectOption(_ swiftyMenu: SwiftyMenu, _ selectedOption: SwiftMenuDisplayable, _ index: Int) {
        guard let viewController = viewController as? FormViewController else {
            return
        }
        viewController.data[menuDataIndex] = ""
    }
}
