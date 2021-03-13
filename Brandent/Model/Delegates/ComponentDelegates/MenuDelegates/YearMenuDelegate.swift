//
//  YearMenuDelegate.swift
//  Brandent
//
//  Created by Sara Babaei on 3/13/21.
//  Copyright © 2021 Sara Babaei. All rights reserved.
//

import Foundation

class YearMenuDelegate: DateMenuDelegate {
    
    override init(viewController: SeeFinanceViewController) {
        super.init(viewController: viewController)
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
        viewController.setDate(yearNumber: index + 1399, monthNumber: nil)
        viewController.financeTableViewDelegate?.date = viewController.date //didSet
    }
    
    override func didUnselectOption(_ swiftyMenu: SwiftyMenu, _ selectedOption: SwiftMenuDisplayable, _ index: Int) {
    }
}
