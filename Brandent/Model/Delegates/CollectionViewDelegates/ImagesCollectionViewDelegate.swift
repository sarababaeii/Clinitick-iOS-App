//
//  ImagesCollectionViewDelegate.swift
//  Brandent
//
//  Created by Sara Babaei on 10/27/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//

import Foundation
import UIKit

class ImagesCollectionViewDelegate: NSObject, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var imagesCollectionView: UICollectionView
    var images = [Image]()
    
    var paitientID: UUID
    
    //MARK: Initializer
    init(imagesCollectionView: UICollectionView, paitientID: UUID) {
        self.imagesCollectionView = imagesCollectionView
        self.paitientID = paitientID
    }
    
    func reset() {
        for img in images {
            deleteImage(img)
        }
    }
    
    //MARK: Delegate Functions
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCellID", for: indexPath) as! ImageCollectionViewCell
        
        if let image = imageDataSource(indexPath: indexPath) {
            cell.setAttributes(image: image, delegate: self)
        }
        return cell
    }
    
    func imageDataSource(indexPath: IndexPath) -> Image? {
        if indexPath.row < images.count {
            return images[indexPath.row]
        }
        return nil
    }
    
    //MARK: Update
    func update(newImages: [Image]) {
        sendImages(newImages: newImages)
        for img in newImages {
            let indexPath = IndexPath(item: images.count, section: 0)
            insertImage(img, at: indexPath)
        }
    }
    
    func insertImage(_ image: Image?, at indexPath: IndexPath?) {
        if let image = image, let indexPath = indexPath {
            imagesCollectionView.performBatchUpdates({
                images.insert(image, at: indexPath.item)
                imagesCollectionView.insertItems(at: [indexPath])
            }, completion: nil)
        }
    }
    
    func deleteImage(_ image: Image) {
        RestAPIManagr.sharedInstance.deleteImage(image: image)
        
        if let indexPath = findIndexOfImage(image) {
            imagesCollectionView.performBatchUpdates({
                images.remove(at: indexPath.item)
                imagesCollectionView.deleteItems(at: [indexPath])
            }, completion: nil)
        }
    }
    
    func findIndexOfImage(_ image: Image) -> IndexPath? {
        if let index =  images.firstIndex(of: image) {
            return IndexPath(item: index, section: 0)
        }
        return nil
    }
    
    func showImage(fileName: String) {
        let image = Image(name: fileName, urlString: API.compressedImageFiles)
        let indexPath = IndexPath(item: images.count, section: 0)
        DispatchQueue.main.async {
            self.insertImage(image, at: indexPath)
        }
    }
    
    //MARK: API Calling
    func sendImages(newImages: [Image]) {
        RestAPIManagr.sharedInstance.addImage(patientID: paitientID, images: newImages)
    }
}
