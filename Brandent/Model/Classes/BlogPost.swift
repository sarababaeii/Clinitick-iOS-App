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
    var image: UIImage
    var title: String
    var link: String
    
    init(image: UIImage, title: String, link: String) {
        self.image = image
        self.title = title
        self.link = link
    }
    
    func openPage() {
//        parentViewController.openPage(item: self)
    }
    
    static func getPostsArray(postsData: NSArray) -> [BlogPost] {
        var posts = [BlogPost]()
        for item in postsData {
            if let postData = item as? NSDictionary, let post = BlogPost.createPost(postData: postData) {
                posts.append(post)
                print("HIIIII")
            }
        }
        return posts
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
        let imageID = String(id)
        getPostImage(imageID: imageID)
        let image = Image(urlString: "https://blog.clinitick.com/wp-json/wp/v2/media?parent=1")
//        print(image.name)
        let post = BlogPost(image: image.compressedImg/*UIImage(named: "welcome")!*/, title: title, link: link)
        print("IM A POST")
        print(post)
        return post
    }
    
    private static func getPostImage(imageID: String) {
        RestAPIManagr.sharedInstance.getPostImage(imageID: imageID, {(result) in
            if let urlString = result {
                let image = Image(urlString: urlString)
                print(image.name)
            }
        })
    }
}
