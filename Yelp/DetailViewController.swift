//
//  DetailViewController.swift
//  Yelp
//
//  Created by Brandon on 4/6/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var reviewLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingImage: UIImageView!
    @IBOutlet weak var ratingCount: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var categoriesLabel: UILabel!
    
    @IBOutlet weak var detailsView: UIView!
    @IBOutlet weak var reviewView: UIView!
    
    
    var isFlipped = false
    
    var business: Business!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        reviewLabel.text = business.snippetText
        nameLabel.text = business.name
        ratingImage.setImageWith(business.ratingImageURL!)
        ratingCount.text = "\(business.reviewCount!) reviews"
        addressLabel.text = business.address
        categoriesLabel.text = business.categories
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? MapViewController {
            vc.businesses = [business]
        }
    }
    
    @IBAction func tapFlip(_ sender: Any) {
        
        if isFlipped {
            UIView.transition(from: detailsView,
                              to: reviewView,
                              duration: 1.0,
                              options: [UIViewAnimationOptions.transitionFlipFromLeft, UIViewAnimationOptions.showHideTransitionViews],
                              completion: nil)
        } else {
            UIView.transition(from: reviewView,
                              to: detailsView,
                              duration: 1.0,
                              options: [UIViewAnimationOptions.transitionFlipFromLeft, UIViewAnimationOptions.showHideTransitionViews],
                              completion: nil)
        }
        isFlipped = !isFlipped
    }
}
