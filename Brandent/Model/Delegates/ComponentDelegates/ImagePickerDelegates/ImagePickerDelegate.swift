//
//  imagePicker.swift
//  Brandent
//
//  Created by Sara Babaei on 10/14/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//

import Foundation
import UIKit
import Photos

class ImagePickerDelegate: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var viewController: UIViewController
    var images = [Image]()
    
    //MARK: Initialization
    init(from viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func displayImagePickingOptions() {
        let alertController = createOptionsAlertController()
        viewController.present(alertController, animated: true)
    }
    
    private func createOptionsAlertController() -> UIAlertController {
        let alertController = UIAlertController(title: "Choose image", message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Take photo", style: .default) { (action) in
            self.displayCamera()
        }
        let libraryAction = UIAlertAction(title: "Library pick", style: .default) { (action) in
            self.displayLibrary()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in }
        alertController.addAction(cameraAction)
        alertController.addAction(libraryAction)
        alertController.addAction(cancelAction)
        return alertController
    }
    
    //MARK: Trouble
    private func troubleAlert(message: String?) {
        let alertController = UIAlertController(title: "Oops...", message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "Got it", style: .cancel)
        alertController.addAction(OKAction)
        viewController.present(alertController, animated: true)
    }
    
    //MARK: Library
    private func displayLibrary() {
        let sourceType = UIImagePickerController.SourceType.photoLibrary
        guard UIImagePickerController.isSourceTypeAvailable(sourceType) else {
            troubleAlert(message: AlertMessage.photos.trouble)
            return
        }
        self.presentLibrary(sourceType: sourceType)
        let status = PHPhotoLibrary.authorizationStatus()
        let noPermissionMessage = AlertMessage.photos.noPermission
        switch status {
        case .notDetermined, .authorized:
            self.presentLibrary(sourceType: sourceType)
        case .denied, .restricted:
            self.troubleAlert(message: noPermissionMessage)
        default:
            print("Anything")
        }
    }
    
    func presentLibrary(sourceType: UIImagePickerController.SourceType) {
        presentImagePicker(sourceType: sourceType)
    }
    
    //MARK: Camera
    private func displayCamera() {
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
    
    private func presentCamera(sourceType: UIImagePickerController.SourceType) {
        presentImagePicker(sourceType: sourceType)
    }
    
    //MARK: Image Picker
    private func presentImagePicker(sourceType: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        imagePicker.allowsEditing = true
        viewController.present(imagePicker, animated: true, completion: nil)
    }
    
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //got an image
        picker.dismiss(animated: true, completion: nil)
        if let newImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            images.append(Image(img: newImage))
            processedPick()
        }
    }
    
    internal func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        //canceled
        picker.dismiss(animated: true, completion: nil)
    }
       
    //MARK: Image Proccessing
    func processedPick() {
    }
}

//TODO: Camera permission
