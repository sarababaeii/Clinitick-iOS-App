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
    var imagePickerDelegate: GalleryImagePickerDelegate?
    
    var patient: Patient?
    
    //MARK: Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    func configure() {
        Info.sharedInstance.isForReturn = true
        guard let _ = patient else {
            print("ERROR in getting patient")
            return
        }
        setTitle(title: "تصاویر")
        setDelegates()
        getImages()
    }
    
    func setDelegates() {
        imageCollectionViewDelegate = ImagesCollectionViewDelegate(imagesCollectionView:imagesCollectionView, paitientID: patient!.id)
        imagesCollectionView.delegate = imageCollectionViewDelegate
        imagesCollectionView.dataSource = imageCollectionViewDelegate
        
        imagePickerDelegate = GalleryImagePickerDelegate(from: self)
    }
    
    func getImages() {
        RestAPIManagr.sharedInstance.getImages(patientID: patient!.id, {(images) in
            guard let images = images else {
                return
            }
            for item in images {
                if let dict = item as? NSDictionary, let imageName = dict["image"] as? String {
                    print("img: \(imageName)")
                    self.imageCollectionViewDelegate?.showImage(fileName: imageName)
                }
            }
        })
    }
    
    @IBAction func addImage(_ sender: Any) {
        imagePickerDelegate?.displayImagePickingOptions()
    }
    
    //MARK: Sending Sender to PatientProfile
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ImageViewSegue",
            let cell = sender as? ImageCollectionViewCell,
            let image = cell.image,
            let viewController = segue.destination as? ImageViewController {
                viewController.image = image
        }
    }
}
