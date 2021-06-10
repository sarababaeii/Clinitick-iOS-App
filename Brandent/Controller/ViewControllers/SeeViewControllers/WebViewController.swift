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

class WebViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    
    var urlString: String?
    var url: URL?
    
    //MARK: Showing NavigationBar
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        configure()
    }
    
    func configure() {
        setURL()
        loadPage()
    }
    
    func setURL() {
        if let link = urlString {
            url = URL(string: link)
        }
    }
    
    func loadPage() {
        if let url = url {
            let request = URLRequest(url: url)
            webView.load(request)
            print(url)
        }
    }
}
