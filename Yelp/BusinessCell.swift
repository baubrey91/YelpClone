//
//  BusinessCell.swift
//  Yelp
//
//  Created by Brandon Aubrey on 4/2/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessCell: UITableViewCell {

    @IBOutlet weak var thumbImageView:      UIImageView!
    @IBOutlet weak var ratingsImageView:    UIImageView!
    @IBOutlet weak var nameLabel:           UILabel!
    @IBOutlet weak var distanceLabel:       UILabel!
    @IBOutlet weak var reviewsCountLabel:   UILabel!
    @IBOutlet weak var addressLabel:        UILabel!
    @IBOutlet weak var categoriesLabel:     UILabel!
    
    var business: Business! {
        didSet {
            nameLabel.text = business.name
            thumbImageView.setImageWith(business.imageURL!)
            categoriesLabel.text = business.categories
            addressLabel.text = business.address
            reviewsCountLabel.text = "\(business.reviewCount!) Reviews"
            ratingsImageView.setImageWith(business.ratingImageURL!)
            distanceLabel.text = business.distance
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        thumbImageView.layer.cornerRadius = 3
        thumbImageView.clipsToBounds = true
    
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
