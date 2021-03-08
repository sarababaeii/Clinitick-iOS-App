//
//  AlergyMenuDelegate.swift
//  Brandent
//
//  Created by Sara Babaei on 3/7/21.
//  Copyright © 2021 Sara Babaei. All rights reserved.
//

import Foundation

class AlergyMenuDelegate: MenuDelegate {
    
    override init(viewController: FormViewController, menuDataIndex: Int) {
        super.init(viewController: viewController, menuDataIndex: menuDataIndex)
    }
    
    //MARK: Collecting Options
    override func prepareMenu(menu: SwiftyMenu) {
        let options = Info.sharedInstance.problems
        if options.count > 0 {
            setMenuDelegates(menu: menu, options: options)
        }
    }
    
    //MARK: Delegate Function
    override func didSelectOption(_ swiftyMenu: SwiftyMenu, _ selectedOption: SwiftMenuDisplayable, _ index: Int) {
        if let alergies = viewController.data[menuDataIndex] as? String {
            viewController.data[menuDataIndex] = alergies + "، " + selectedOption.displayValue
        }
    }
}
