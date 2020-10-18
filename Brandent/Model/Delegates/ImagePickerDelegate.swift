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
import Photos

enum message {
    case camera
    case photos
    
    var noPermission: String {
        let firstSentence = "Looks like Brandent doesn't have access to your"
        let secondSentence = ". Please use Settings App on your device to permit Brandent accessing your"
        
        switch self {
        case .camera:
            return "\(firstSentence) camera\(secondSentence) camera."
        case .photos:
            return "\(firstSentence) photos\(secondSentence) photos."
        }
    }
    
    var trouble: String {
        let firstPhrase = "Sincere apologies, it looks like we can't access your"
        let secondPhrase = "at this time."
        
        switch self {
        case .camera:
            return "\(firstPhrase) camera \(secondPhrase)"
        case .photos:
            return "\(firstPhrase) photos \(secondPhrase)"
        }
    }
}

class ImagePickerDelegate: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    var viewController: UIViewController
    
    init(from viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func displayImagePickingOptions(){
        let alertController = UIAlertController(title: "Choose image", message: nil, preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Take photo", style: .default){
            (action) in
            self.displayCamera()
        }
        alertController.addAction(cameraAction)
        
        let libraryAction = UIAlertAction(title: "Library pick", style: .default){
            (action) in
            self.displayLibrary()
        }
        alertController.addAction(libraryAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel){
            (action) in
        }
        alertController.addAction(cancelAction)
        
        viewController.present(alertController, animated: true)
    }
    
    func displayCamera(){
        let sourceType = UIImagePickerController.SourceType.camera
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
            let noPermissionMessage = message.camera.noPermission

            switch status{
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: {(granted) in
                    if granted{
                        self.presentImagePicker(sourceType: sourceType)
                    }
                    else{
                        self.troubleAlert(message: noPermissionMessage)
                    }
                })
            case .authorized:
                self.presentImagePicker(sourceType: sourceType)
            case .denied, .restricted:
                self.troubleAlert(message: noPermissionMessage)
            default:
                print("Anything")
            }
        }
        else{
            troubleAlert(message: message.camera.trouble)
        }
    }
        
    func displayLibrary(){
        let sourceType = UIImagePickerController.SourceType.photoLibrary
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            let status = PHPhotoLibrary.authorizationStatus()
            let noPermissionMessage = message.photos.noPermission
         
            switch status {
            case .notDetermined:
                PHPhotoLibrary.requestAuthorization({(newStatus) in
                    if newStatus == .authorized{
                        self.presentImagePicker(sourceType: sourceType)
                    }
                    else {
                        self.troubleAlert(message: noPermissionMessage)
                    }
                })
            case .authorized:
                self.presentImagePicker(sourceType: sourceType)
            case .denied, .restricted:
                self.troubleAlert(message: noPermissionMessage)
            default:
                print("Anything")
            }
        }
        else{
            troubleAlert(message: message.photos.trouble)
        }
    }
        
    func presentImagePicker(sourceType: UIImagePickerController.SourceType){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        viewController.present(imagePicker, animated: true, completion: nil)
    }
        
    func troubleAlert(message: String?){
        let alertController = UIAlertController(title: "Oops...", message: message, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "Got it", style: .cancel)
        alertController.addAction(OKAction)
        viewController.present(alertController, animated: true)
    }
        
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //got an image
        picker.dismiss(animated: true, completion: nil)
        let newImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        processedPick(image: newImage)
    }
        
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        //canceled
        picker.dismiss(animated: true, completion: nil)
    }
        
    func processedPick(image: UIImage?){
        if let newImage = image{
            print(newImage as Any)
//            creation.image = newImage
//            animateImageChange()
        }
    }
}
