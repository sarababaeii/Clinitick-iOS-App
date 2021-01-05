//
//  SeeImagesViewController.swift
//  Brandent
//
//  Created by Sara Babaei on 12/14/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//

import Foundation
import UIKit

class GalleryViewController: NavigationBarViewController {
    
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    
    var imageCollectionViewDelegate: ImagesCollectionViewDelegate?
    var imagePickerDelegate: ImagePickerDelegate?
    
    var patient: Patient?
    
    //MARK: Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    func configure() {
        guard let _ = patient else {
            print("ERROOOOOOOOOOOOOR")
            return
        }
        setTitle(title: "تصاویر")
        setDelegates()
    }
    
    func setDelegates() {
        imageCollectionViewDelegate = ImagesCollectionViewDelegate(imagesCollectionView:imagesCollectionView, paitientID: patient!.id)
        imagesCollectionView.delegate = imageCollectionViewDelegate
        imagesCollectionView.dataSource = imageCollectionViewDelegate
        
        imagePickerDelegate = ImagePickerDelegate(from: self)
    }
    
    @IBAction func addImage(_ sender: Any) {
        imagePickerDelegate?.displayImagePickingOptions()
    }
}
