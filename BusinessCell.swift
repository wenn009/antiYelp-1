//
//  BusinessCell.swift
//  Yelp
//
//  Created by Ekko Lin on 2/17/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessCell: UITableViewCell {

    
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var reviewLabel: UILabel!
    @IBOutlet weak var ratingView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var thumbView: UIImageView!
    
    var business: Business! {
        didSet {
            nameLabel.text = business.name
            thumbView.setImageWith(business.imageURL!)
            categoryLabel.text = business.categories
            addressLabel.text = business.address
            reviewLabel.text = "\(business.reviewCount!) Reviews"
            ratingView.setImageWith(business.ratingImageURL!)
            distanceLabel.text = business.distance
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        thumbView.layer.cornerRadius = 25
        thumbView.clipsToBounds = true
        
        nameLabel.preferredMaxLayoutWidth = nameLabel.frame.size.width
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        nameLabel.preferredMaxLayoutWidth = nameLabel.frame.size.width
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }


}
