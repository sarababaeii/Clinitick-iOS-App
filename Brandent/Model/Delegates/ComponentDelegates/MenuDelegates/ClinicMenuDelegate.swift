//
//  ClinicMenuDelegate.swift
//  Brandent
//
//  Created by Sara Babaei on 3/7/21.
//  Copyright © 2021 Sara Babaei. All rights reserved.
//

import Foundation

class ClinicMenuDelegate: MenuDelegate {
    
    override init(viewController: FormViewController, menuDataIndex: Int) {
        super.init(viewController: viewController, menuDataIndex: menuDataIndex)
    }
    
    //MARK: Clinic Functions
    override func prepareMenu(menu: SwiftyMenu) {
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
}
