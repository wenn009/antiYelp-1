//
//  Post.swift
//  Yelp
//
//  Created by Wenn Huang on 4/9/17.
// 
//

import UIKit
import Parse

class Post: NSObject {
    
    class func postUserImage(image: UIImage?, withCaption caption: String?, withRestaurant restaurant: String?, withCompletion completion: PFBooleanResultBlock?)
    {
        let post = PFObject(className: "Post")
        
        post["Restaurant"] = restaurant
        post["media"] = getPFFileFromImage(image: image) // PFFile column type
        post["author"] = PFUser.current() // Pointer column type that points to PFUser
        post["caption"] = caption
       
        
        let timeStamp = NSDate()
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE MM d HH:mm:ss Z y"
        post["timeStamp"] = formatter.string(from: timeStamp as Date)
        
        // Save object (following function will save the object in Parse asynchronously)
        post.saveInBackground(block: completion)
    }
    
    class func getPFFileFromImage(image: UIImage?) -> PFFile? {
        // check if image is not nil
        if let image = image {
            // get image data and check if that is not nil
            if let imageData = UIImagePNGRepresentation(image) {
                return PFFile(name: "image.png", data: imageData)
            }
        }
        return nil
    }


}
