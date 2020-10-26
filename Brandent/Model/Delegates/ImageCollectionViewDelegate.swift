//
//  ImageCollectionViewDelegate.swift
//  Brandent
//
//  Created by Sara Babaei on 10/26/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//

import Foundation
import UIKit

class ImageCollectionViewDelegate: NSObject, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var imagesCollectionView: UICollectionView
    var images = [UIImage(named: "profile"), UIImage(named: "white_tick"), UIImage(named: "diseases")]
    
    //MARK: Initializer
    init(imagesCollectionView: UICollectionView) {
        self.imagesCollectionView = imagesCollectionView
        print("Delegate initialized")
    }
    
    //MARK: Protocol Functions
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("Count: \(images.count)")
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCellID", for: indexPath) as! ImageCollectionViewCell
        
        print("Cell generated for \(indexPath.row), \(indexPath.item)")
        if let image = imageDataSource(indexPath: indexPath) {
            cell.setAttributes(image: image)
        }
        return cell
    }
    
    func imageDataSource(indexPath: IndexPath) -> UIImage? {
        print("Wants image in \(indexPath.row)")
        if indexPath.row < images.count {
            return images[indexPath.row]
        }
        return nil
    }
    
    //MARK: Functions
    func insertImage(_ image: UIImage?, at indexPath: IndexPath?) {
        if let image = image, let indexPath = indexPath {
            imagesCollectionView.performBatchUpdates({
                images.insert(image, at: indexPath.item)
                imagesCollectionView.insertItems(at: [indexPath])
            }, completion: nil)
        }
    }

    func deletePlayer(at indexPath: IndexPath?) {
        if let indexPath = indexPath {
            imagesCollectionView.performBatchUpdates({
                images.remove(at: indexPath.item)
                imagesCollectionView.deleteItems(at: [indexPath])
            }, completion: nil)
        }
    }
    
//    func updatePlayers(users: [[String : Any]]) {
//        while Game.sharedInstance.players.count > 0 {
//            deletePlayer(at: IndexPath(item: Game.sharedInstance.players.count - 1, section: 0))
//        }
//        
//        for user in users {
//            let player = Player(socketID: user["socket_id"] as! String, username: user["name"] as! String, colorCode: user["color"] as! Int)
//            let indexPath = IndexPath(item: Game.sharedInstance.players.count, section: 0)
//            
//            if player.isMe() {
//                Game.sharedInstance.me.colorCode = player.colorCode
//                insertPlayer(Game.sharedInstance.me, at: indexPath)
//            } else {
//                insertPlayer(player, at: indexPath)
//            }
//        }
//    }
}
