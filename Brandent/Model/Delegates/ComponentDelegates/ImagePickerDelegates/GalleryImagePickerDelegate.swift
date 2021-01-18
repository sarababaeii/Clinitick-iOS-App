//
//  GalleryImagePickerDelegate.swift
//  Brandent
//
//  Created by Sara Babaei on 1/18/21.
//  Copyright © 2021 Sara Babaei. All rights reserved.
//

import Foundation
import UIKit
import BSImagePicker
import Photos

class GalleryImagePickerDelegate: ImagePickerDelegate {
    
    var selectedAssets = [PHAsset]()
    
    //MARK: Initialization
    init(from viewController: GalleryViewController) {
        super.init(from: viewController)
    }
    
    override func presentLibrary(sourceType: UIImagePickerController.SourceType){
        let vc = BSImagePickerViewController()
        viewController.bs_presentImagePickerController(vc, animated: true, select: { (assest: PHAsset) -> Void in
            print(assest)
        },  deselect: { (assest: PHAsset) -> Void in
        }, cancel: { (assest: [PHAsset]) -> Void in
        }, finish: { (assest: [PHAsset]) -> Void in
            for i in 0..<assest.count {
                self.selectedAssets.append(assest[i])
            }
            self.convertAssetToImages()
        }, completion: nil)
    }
       
    //MARK: Image Proccessing
    func convertAssetToImages() -> Void {
        if selectedAssets.count == 0 {
            return
        }
        for img in selectedAssets {
            let manager = PHImageManager.default()
            let option = PHImageRequestOptions()
            var thumbnail = UIImage()
            option.isSynchronous = true
            manager.requestImage(for: img, targetSize: CGSize(width: 84, height: 84), contentMode: .aspectFill, options: option, resultHandler: {(result,info) -> Void in
                thumbnail = result!
            })
            let data = thumbnail.jpegData(compressionQuality: 1)
            self.images.append(Image(img: data!))
        }
        processedPick()
    }
        
    override func processedPick() {
        guard let viewController = viewController as? GalleryViewController else {
            return
        }
        if let delegate = viewController.imageCollectionViewDelegate {
            delegate.update(newImages: images)
        }
        selectedAssets = [PHAsset]()
        images = [Image]()
    }
}
