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
//    var color: Color
    var image: UIImage
    var title: String
    var link: String
    
    
//    var parentViewController: HomeViewController
//    var viewControllerIdentifier: String
//    var tabBarItemIndex: Int
    
//    init(color: Color, image: UIImage, title: String, parentViewController: HomeViewController, viewControllerIdentifier: String, tabBarItemIndex: Int) {
//        self.color = color
//        self.image = image
//        self.title = title
//        self.parentViewController = parentViewController
//        self.viewControllerIdentifier = viewControllerIdentifier
//        self.tabBarItemIndex = tabBarItemIndex
//    }
    
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
        
        let post = BlogPost(image: UIImage(named: "welcome")!, title: title, link: link)
        print("IM A POST")
        print(post)
        return post
    }
}
