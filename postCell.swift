//
//  postCell.swift
//  Yelp
//
//  Created by Wenn Huang on 4/9/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit
import Parse

class postCell: UITableViewCell {
    
    @IBOutlet weak var restaurantName: UILabel!
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var postDescriptionLabel: UILabel!
    
    var post : PFObject! {
        didSet {
            
            postDescriptionLabel.text = post["caption"] as! String
            restaurantName.text = post["restaurant"] as! String
            let userImageFile = post["media"] as! PFFile
            userImageFile.getDataInBackground {
                (imageData, error)  in
                if !(error != nil) {
                    let image = UIImage(data:imageData!)
                    self.photoView.image = image
                }
            }
            
            
            
            
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
