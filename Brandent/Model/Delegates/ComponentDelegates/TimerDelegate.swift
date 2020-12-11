//
//  TimerDelegate.swift
//  Brandent
//
//  Created by Sara Babaei on 12/9/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//

import Foundation
import UIKit

class TimerDelegate {
    var timer: Timer?
    let label: UILabel
    var counter: Int
    let viewController: UIViewController
    
    init(label: UILabel, time: Int, from viewController: UIViewController) {
        self.label = label
        self.counter = time
        self.viewController = viewController
        
        on()
    }
    
    func on() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
    }
    
    func off() {
        timer?.invalidate()
    }
    
    @objc func updateCounter() {
        if counter > 0 {
            counter -= 1
            setTimerLabel(counter: counter)
        }
        
        if counter == 0 {
            off()
            if let viewController = viewController as? CodeViewController {
                viewController.timerFinished()
            }
        }
    }
    
    func setTimerLabel(counter: Int) {
        var counterString = String(counter).convertEnglishNumToPersianNum()
        if counter <= 9 {
            counterString = "۰\(counterString)"
        }
        label.text = "۰:\(counterString)"
    }
}
