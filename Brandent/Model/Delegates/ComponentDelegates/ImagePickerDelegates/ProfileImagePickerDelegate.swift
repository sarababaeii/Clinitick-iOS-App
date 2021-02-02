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
    init(from viewController: ProfileViewController) {
        super.init(from: viewController)
    }
       
    //MARK: Image Proccessing
    override func processedPick() {
        guard let viewController = viewController as? ProfileViewController, images.count > 0 else {
            return
        }
        viewController.dentistImageView.image = images[0].img
        if let dentist = Info.sharedInstance.dentist {
            DataController.sharedInstance.setDentistPhoto(dentist: dentist, photo: images[0])
        }
        selectedAssets = [PHAsset]()
        images = [Image]()
    }
}
