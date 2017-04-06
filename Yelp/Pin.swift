//
//  Pin.swift
//  Yelp
//
//  Created by Brandon on 4/6/17.
//  Copyright © 2017 Brandon Aubrey. All rights reserved.
//

import MapKit

class Pin: NSObject, MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    
    init(title: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.coordinate = coordinate
    }
}
