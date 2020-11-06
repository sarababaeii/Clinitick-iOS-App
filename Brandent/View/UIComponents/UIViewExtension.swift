//
//  UIViewExtension.swift
//  Brandent
//
//  Created by Sara Babaei on 11/5/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    private func getSubviews(view: UIView) -> [UIView]? {
        if view.subviews.count == 0 {
            return nil
        }
        var subviews = view.subviews
        for subview in view.subviews {
            if let subsubviews = getSubviews(view: subview) {
                subviews.append(contentsOf: subsubviews)
            }
        }
        return subviews
    }
}
