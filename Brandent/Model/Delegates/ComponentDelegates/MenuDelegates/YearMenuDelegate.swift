//
//  YearMenuDelegate.swift
//  Brandent
//
//  Created by Sara Babaei on 3/13/21.
//  Copyright © 2021 Sara Babaei. All rights reserved.
//

import Foundation

class YearMenuDelegate: MenuDelegate {
    
    init(viewController: SeeFinanceViewController) {
        super.init(viewController: viewController, menuDataIndex: 0)
    }
    
    //MARK: Collecting Options
    override func prepareMenu(menu: SwiftyMenu) {
        var options = [String]()
        for i in 1399 ..< 1441 {
            options.append(String(i).convertEnglishNumToPersianNum())
        }
        setMenuDelegates(menu: menu, options: options)
    }
      
    override func didSelectOption(_ swiftyMenu: SwiftyMenu, _ selectedOption: SwiftMenuDisplayable, _ index: Int) {
        guard let viewController = viewController as? SeeFinanceViewController else {
            return
        }
        viewController.setDate(yearNumber: index + 1399, monthNumber: nil)
    }
    
    override func didUnselectOption(_ swiftyMenu: SwiftyMenu, _ selectedOption: SwiftMenuDisplayable, _ index: Int) {
    }
}
