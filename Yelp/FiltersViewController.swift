//
//  FiltersViewController.swift
//  Yelp
//
//  Created by Brandon Aubrey on 4/3/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit
import Pods_Yelp

class FiltersViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var categories : [[String:String]]!
    override func viewDidLoad() {
        super.viewDidLoad()

        //categories = yelpCategories()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func Search(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
