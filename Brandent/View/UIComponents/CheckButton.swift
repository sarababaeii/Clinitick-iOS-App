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
    
    var discreption: TaskState {
        get {
            if tag % 2 == 0 {
                return .canceled
            } else {
                return .done
            }
        }
    }
    
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
    
    func selectCheckButton() {
        self.backgroundColor = selectedColor
        self.setImage(selectedAlergyButtonImages[self.tag], for: .normal)
    }
    
    func unselectCheckButton() {
        self.backgroundColor = UIColor.white
        self.setImage(unselectedAlergyButtonImages[self.tag], for: .normal)
    }
    
    func visibleSelection() {
        self.selectCheckButton()
        if let otherButton = self.getOtherButton() {
            otherButton.unselectCheckButton()
        }
    }
    
    func hasAlergy() -> Bool {
        if self.tag == 0 {
            return false
        }
        return true
    }
}
