//
//  MenuCollectionViewDelegate.swift
//  Brandent
//
//  Created by Sara Babaei on 11/5/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//

import Foundation
import UIKit

class MenuCollectionViewDelegate: NSObject, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var viewController: HomeViewController
    var items = [BlogPost]()
    
    //MARK: Initializer
    init(viewController: HomeViewController) {
        self.viewController = viewController
        super.init()
        createTestPosts()
    }
    
    //MARK: Protocol Functions
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuCellID", for: indexPath) as! MenuCollectionViewCell
        if let item = menuDataSource(indexPath: indexPath) {
            cell.setAttributes(item: item)
        }
        return cell
    }
    
    func menuDataSource(indexPath: IndexPath) -> BlogPost? {
        if indexPath.row < items.count {
            return items[indexPath.row]
        }
        return nil
    }
    
    private func createTestPosts() {
        items.append(BlogPost(image: UIImage(named: "welcome")!, title: "دوره آموزشی رایگان جدید ترین روش های درمانی در اروپا و آمریکا"))
        items.append(BlogPost(image: UIImage(named: "daily_tasks")!, title: "پزشکان ثروتمند"))
    }
}
