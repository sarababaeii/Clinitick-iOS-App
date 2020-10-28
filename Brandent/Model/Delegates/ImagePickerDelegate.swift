//
//  imagePicker.swift
//  Brandent
//
//  Created by Sara Babaei on 10/14/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit
import BSImagePicker
import Photos

class ImagePickerDelegate: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var viewController: AddViewController
    var imagesCollectionViewDelegate: ImagesCollectionViewDelegate?
    
    var selectedAssets = [PHAsset]()
    var photoArray = [UIImage]()
    
    init(from viewController: AddViewController, imagesCollectionViewDelegate: ImagesCollectionViewDelegate?) {
        self.viewController = viewController
        self.imagesCollectionViewDelegate = imagesCollectionViewDelegate
    }
    
    func displayImagePickingOptions(){
        let alertController = UIAlertController(title: "Choose image", message: nil, preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Take photo", style: .default) { (action) in
            self.displayCamera()
        }
        alertController.addAction(cameraAction)
        let libraryAction = UIAlertAction(title: "Library pick", style: .default) { (action) in
            self.displayLibrary()
        }
        alertController.addAction(libraryAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
        }
        alertController.addAction(cancelAction)
        
        viewController.present(alertController, animated: true)
    }
    
    func displayCamera(){
        let sourceType = UIImagePickerController.SourceType.camera
        guard UIImagePickerController.isSourceTypeAvailable(sourceType) else {
            troubleAlert(message: AlertMessage.camera.trouble)
            return
        }
        let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        let noPermissionMessage = AlertMessage.camera.noPermission
        switch status {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted) in
                if granted {
                    self.presentCamera(sourceType: sourceType)
                } else {
                    self.troubleAlert(message: noPermissionMessage)
                }
            })
        case .authorized:
            self.presentCamera(sourceType: sourceType)
        case .denied, .restricted:
            self.troubleAlert(message: noPermissionMessage)
        default:
            print("Anything")
        }
    }
    
    func presentCamera(sourceType: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        imagePicker.allowsEditing = true
        viewController.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //got an image
        picker.dismiss(animated: true, completion: nil)
        if let newImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            photoArray.append(newImage)
            processedPick()
        }
    }
    
    func displayLibrary() {
        let sourceType = UIImagePickerController.SourceType.photoLibrary
        guard UIImagePickerController.isSourceTypeAvailable(sourceType) else {
            troubleAlert(message: AlertMessage.photos.trouble)
            return
        }
        let status = PHPhotoLibrary.authorizationStatus()
        let noPermissionMessage = AlertMessage.photos.noPermission
        switch status {
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({(newStatus) in
                if newStatus == .authorized {
                    self.presentImagePicker()
                } else {
                    self.troubleAlert(message: noPermissionMessage)
                }
            })
        case .authorized:
            self.presentImagePicker()
        case .denied, .restricted:
            self.troubleAlert(message: noPermissionMessage)
        default:
            print("Anything")
        }
    }
        
    func presentImagePicker(){
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
            let newImage = UIImage(data: data!)
            self.photoArray.append(newImage! as UIImage)
        }
        processedPick()
    }
    
    func troubleAlert(message: String?){
        let alertController = UIAlertController(title: "Oops...", message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "Got it", style: .cancel)
        alertController.addAction(OKAction)
        viewController.present(alertController, animated: true)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        //canceled
        picker.dismiss(animated: true, completion: nil)
    }
        
    func processedPick(){
        if let delegate = imagesCollectionViewDelegate {
            print(photoArray[0])
            delegate.update(newImages: photoArray)
        }
        selectedAssets = [PHAsset]()
        photoArray = [UIImage]()
    }
}

//TODO: Set Camera photos
