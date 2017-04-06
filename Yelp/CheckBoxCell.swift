//
//  CheckBoxCell.swift
//  Yelp
//
//  Created by Brandon on 4/5/17.
//  Copyright © 2017 Brandon Aubrey. All rights reserved.
//

import UIKit

class CheckBoxCell: UITableViewCell {

    @IBOutlet weak var checkLabel: UILabel!
    @IBOutlet weak var checkImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
