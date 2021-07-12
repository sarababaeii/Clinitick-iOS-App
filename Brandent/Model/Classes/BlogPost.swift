//
//  MenuItem.swift
//  Brandent
//
//  Created by Sara Babaei on 11/5/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//

import Foundation
import UIKit

class BlogPost {
    var title: String
    var link: String
    var imageID: String
    var image: UIImage?
    
    init(title: String, link: String, imageID: String) {
        self.title = title
        self.link = link
        self.imageID = imageID
    }
    
    func openPage() {
//        parentViewController.openPage(item: self)
    }
    
    static func getPostsArray(postsData: NSArray, _ completion: @escaping ([BlogPost]?) -> ()) {
        var posts = [BlogPost]()
        for item in postsData {
            if let postData = item as? NSDictionary {
                if let post = BlogPost.createPost(postData: postData) {
                    posts.append(post)
                }
            }
        }
        completion(posts)
    }
    
    static func createPost(postData: NSDictionary) -> BlogPost? {
        guard let titleContainer = postData["title"] as? NSDictionary, let title = titleContainer["rendered"] as? String else {
            print("Could not save TITLE")
            return nil
        }
        guard let link = postData["link"] as? String else {
            print("Could not save LINK")
            return nil
        }
        guard let id = postData["featured_media"] as? Int else {
            print("Could not save IMAGE ID")
            return nil
        }
        print("POST DATA:\n\(title)\n\(link)\n\(id)")
        let imageID = String(id)
        let post = BlogPost(title: title, link: link, imageID: imageID)
        return post
    }
    
    private func getPostImageLink(_ completion: @escaping (String?) -> ()) {
        RestAPIManagr.sharedInstance.getPostImageLink(imageID: imageID, {(result) in
            if let urlString = result {
                completion(urlString)
            }
        })
    }
    
    func getImage(_ completion: @escaping (UIImage?) -> ()) {
        if let image = self.image {
            completion(image)
        } else {
            self.setImage({(image) in
                completion(image)
            })
        }
    }
    
    private func setImage(_ completion: @escaping (UIImage) -> ()) {
        self.getPostImageLink({(url) in
            if let urlString = url {
                let image = Image(urlString: urlString)
                self.image = image.compressedImg
                print("Image got")
                completion(image.compressedImg)
            }
        })
    }
}
