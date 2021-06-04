//
//  SeeBlogPostViewController.swift
//  Brandent
//
//  Created by Sara Babaei on 6/4/21.
//  Copyright © 2021 Sara Babaei. All rights reserved.
//

import Foundation
import UIKit
import WebKit

class SeeBlogPostViewController: UIViewController {
    
    @IBOutlet weak var postWebView: WKWebView!
    
    var urlString: String?
    
    //MARK: Showing NavigationBar
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        configure()
    }
    
    func configure() {
        setURL()
    }
    
    func setURL() {
        if let link = urlString, let url = URL(string: link) {
            let request = URLRequest(url: url)
            postWebView.load(request)
            
        }
    }
}
