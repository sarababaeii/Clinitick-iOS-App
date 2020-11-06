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
    
    var items = [MenuItem]()
    
    //MARK: Initializer
    override init() {
        items.append(MenuItem(color: Color.pink, image: UIImage(named: "patients_in_home")!, title: "لیست بیماران", viewControllerIdentifier: "PatientsViewController"))
        items.append(MenuItem(color: Color.green, image: UIImage(named: "wallet")!, title: "درآمد این ماه", viewControllerIdentifier: "FinanceListsViewController"))
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
    
    func menuDataSource(indexPath: IndexPath) -> MenuItem? {
        if indexPath.row < items.count {
            return items[indexPath.row]
        }
        return nil
    }
}
