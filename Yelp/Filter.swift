//
//  Filter.swift
//  Yelp
//
//  Created by Brandon Aubrey on 4/8/17.
//  Copyright © 2017 Brandon Aubrey. All rights reserved.
//

import Foundation

class Filter {
    
    var name: String
    var values: [[String:String]]
    var isExpanded : Bool
    var expandValue : Int
    
    init(name: String, values: [[String:String]], isExpanded: Bool, expandValue: Int) {
        self.name = name
        self.values = values
        self.isExpanded = isExpanded
        self.expandValue = expandValue
    }
}
