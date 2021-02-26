//
//  SwiftyMenuExtension.swift
//  Brandent
//
//  Created by Sara Babaei on 11/12/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//

import Foundation

extension SwiftyMenu {
    func showError() {
        if self.placeHolderColor != Color.red.componentColor {
            self.placeHolderText = "*\(self.placeHolderText!)"
            self.placeHolderColor = Color.red.componentColor
        }
    }
}
