//
//  User.swift
//  Yelp
//
//  Created by Wenn Huang on 4/9/17.


import UIKit
import Parse 

class User: PFUser {
    
    class func fetchPosts(sucess: @escaping ([PFObject]?) -> (), failure: @escaping (NSError?) -> () )
    {
        let query = PFQuery(className: "Post")
        query.order(byDescending: "createdAt")
        query.includeKey("updated_at")
        query.includeKey("author")
        query.limit = 20
        
        // fetch data asynchronously
        query.findObjectsInBackground { (posts, error) in
            if let posts = posts
            {
                sucess(posts)
            }
            else
            {
                failure(error as NSError?)
            }
        }
    }
    
    class func fetchMyPosts(sucess: @escaping ([PFObject]?) -> (), failure: @escaping (NSError?) -> () )
    {
        let query = PFQuery(className: "Post")
        query.whereKey("author", equalTo: PFUser.current()!)
        query.order(byDescending: "createdAt")
        query.includeKey("updated_at")
        query.includeKey("author")
        query.limit = 20
        
        // fetch data asynchronously
        query.findObjectsInBackground { (posts, error) in
            if let posts = posts
            {
                sucess(posts)
            }
            else
            {
                failure(error as NSError?)
            }
        }
    }
}
