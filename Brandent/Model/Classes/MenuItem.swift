//
//  MenuItem.swift
//  Brandent
//
//  Created by Sara Babaei on 11/5/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//

import Foundation
import UIKit

class MenuItem {
    var color: Color
    var image: UIImage
    var title: String
    
    var parentViewController: HomeViewController
    var viewControllerIdentifier: String
    var tabBarItemIndex: Int
    
    init(color: Color, image: UIImage, title: String, parentViewController: HomeViewController, viewControllerIdentifier: String, tabBarItemIndex: Int) {
        self.color = color
        self.image = image
        self.title = title
        self.parentViewController = parentViewController
        self.viewControllerIdentifier = viewControllerIdentifier
        self.tabBarItemIndex = tabBarItemIndex
    }
    
    func openPage() {
        parentViewController.openPage(item: self)
    }
}
