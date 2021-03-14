//
//  AlergyMenuDelegate.swift
//  Brandent
//
//  Created by Sara Babaei on 3/7/21.
//  Copyright © 2021 Sara Babaei. All rights reserved.
//

import Foundation

class AllergyMenuDelegate: MenuDelegate {
    
    init(viewController: FormViewController, menuDataIndex: Int) {
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
        guard let viewController = viewController as? FormViewController else {
            return
        }
        viewController.isSelectedAlergies[selectedOption.displayValue] = true
        updateSelectedAllergies()
    }
    
    override func didUnselectOption(_ swiftyMenu: SwiftyMenu, _ selectedOption: SwiftMenuDisplayable, _ index: Int) {
        guard let viewController = viewController as? FormViewController else {
            return
        }
        viewController.isSelectedAlergies[selectedOption.displayValue] = false
        updateSelectedAllergies()
    }
    
    private func updateSelectedAllergies() {
        guard let viewController = viewController as? FormViewController else {
            return
        }
        if let allergies = allSelectedAllergies() {
            viewController.data[menuDataIndex] = allergies
        }
        print(viewController.data[menuDataIndex])
    }
    
    private func allSelectedAllergies() -> String? {
        guard let viewController = viewController as? FormViewController else {
            return nil
        }
        var allergies = ""
        for problem in Info.sharedInstance.problems {
            if let isSelected = viewController.isSelectedAlergies[problem], isSelected == true {
                allergies += "," + problem
            }
        }
        return allergies
    }
}
