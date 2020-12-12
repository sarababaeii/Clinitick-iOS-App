//
//  UIViewControllerExtension.swift
//  Brandent
//
//  Created by Sara Babaei on 10/10/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    //MARK: Showing Next ViewController
    func showNextPage(identifier: String) {
         let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: identifier) as UIViewController
        self.present(controller, animated: true, completion: nil)
//        navigationController?.show(controller, sender: nil)
    }
    
    //MARK: Toast
    func showToast(message : String) {
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 124, y: self.view.frame.size.height-130, width: 310, height: 41)) //TODO: set size
        toastLabel.backgroundColor = Color.red.componentColor
        toastLabel.textColor = UIColor.white
        toastLabel.font = UIFont(name: "Vazir", size: 16)
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 20;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        
        UIView.animate(withDuration: 4.0, delay: 1, options: .curveEaseOut, animations: {
             toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    //MARK: Setting Gradient Layers
    func setGradientSizes() {
        guard let subviews = getSubviews(view: self.view) else {
            return
        }
        for subview in subviews {
            if let view = subview as? LightningUIView {
                view.resizeGradientLayer()
            }
        }
    }
    
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
