//
//  CheckAlergyButton.swift
//  Brandent
//
//  Created by Sara Babaei on 10/15/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//

import Foundation
import UIKit

class CheckButton: CustomButton {
    @IBInspectable var selectedColor: UIColor = UIColor.white {
        didSet {
            
        }
    }
    
    let selectedAlergyButtonImages = [UIImage(named: "white_close"), UIImage(named: "white_tick")]
    let unselectedAlergyButtonImages = [UIImage(named: "black_close"), UIImage(named: "black_tick")]
    
    func getOtherButton() -> CheckButton? {
        guard let siblings = self.superview?.subviews else {
            return nil
        }
        for view in siblings {
            if let btn = view as? CheckButton {
                if btn.tag != self.tag {
                    return btn
                }
            }
        }
        return nil
    }
    
    func selectAlergyButton() {
        self.backgroundColor = selectedColor
        self.setImage(selectedAlergyButtonImages[self.tag], for: .normal)
    }
    
    func unselectAlergyButton() {
        self.backgroundColor = UIColor.white
        self.setImage(unselectedAlergyButtonImages[self.tag], for: .normal)
    }
    
    func visibleSelection() {
        self.selectAlergyButton()
        if let otherButton = self.getOtherButton() {
            otherButton.unselectAlergyButton()
        }
    }
    
    func hasAlergy() -> Bool {
        if self.tag == 0 {
            return false
        }
        return true
    }
}
