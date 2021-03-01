//
//  ProfileImagePickerDelegate.swift
//  Brandent
//
//  Created by Sara Babaei on 1/18/21.
//  Copyright © 2021 Sara Babaei. All rights reserved.
//

import Foundation
import UIKit
import BSImagePicker
import Photos

class ProfileImagePickerDelegate: ImagePickerDelegate {
    
    var selectedAssets = [PHAsset]()
    
    //MARK: Initialization
    override init(from viewController: UIViewController) {
        super.init(from: viewController)
    }
       
    //MARK: Image Proccessing
    override func processedPick() {
        guard images.count > 0 else {
            return
        }
        setForDentist()
        showImage()
        deinitialize()
    }
    
    func setForDentist() {
        RestAPIManagr.sharedInstance.setProfilePicture(photo: images)
        if let dentist = Info.sharedInstance.dentist {
            dentist.setProfilePicture(photo: images[0], fromAPI: false)
//            DataController.sharedInstance.setDentistPhoto(dentist: dentist, photo: images[0])
        }
    }
    
    func showImage() {
        if let viewController = viewController as? ProfileViewController {
            viewController.dentistImageView.image = images[0].img
            viewController.addImageButton.setImage(nil, for: .normal)
        }
        
        if let viewController = viewController as? InformationViewController {
            viewController.dentistImageView.image = images[0].img
            viewController.addImageButton.setImage(nil, for: .normal)
        }
    }
    
    func deinitialize() {
        selectedAssets = [PHAsset]()
        images = [Image]()
    }
}
