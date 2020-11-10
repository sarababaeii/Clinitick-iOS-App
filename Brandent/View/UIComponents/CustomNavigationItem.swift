//
//  CustomNavigationViewController.swift
//  Brandent
//
//  Created by Sara Babaei on 11/6/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//

import Foundation
import UIKit

class CustomNavigationBar: UINavigationBar {
    @IBInspectable var height: CGFloat = 72 {
        didSet {
            self.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: height)
            print(self.frame.size.height)
        }
    }
    
    @IBInspectable var backFontStyle: String = "Vazir" {
        didSet {
            setBackButtonFont(style: backFontStyle, size: backFontSize)
        }
    }
    
    @IBInspectable var backFontSize: CGFloat = 18 {
        didSet {
            setBackButtonFont(style: backFontStyle, size: backFontSize)
        }
    }
    
    func setBackButtonFont(style: String, size: CGFloat) {
        guard let items = self.items else {
            return
        }
        for item in items {
            item.backBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: style, size: size)!], for: UIControl.State.normal)
        }
    }
}

//let rightItem = UIBarButtonItem(title: "Title", style: UIBarButtonItem.Style.plain, target: nil, action: nil)
//rightItem.isEnabled = false
//rightItem.tintColor = UIColor.black
//item.rightBarButtonItem = rightItem
//print(item.title)
