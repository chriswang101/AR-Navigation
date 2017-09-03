//
//  Locations.swift
//  AR Navigation
//
//  Created by Chris Wang on 8/15/17.
//  Copyright © 2017 Chris Wang. All rights reserved.
//

import Foundation
import CoreLocation

class location: NSObject {
    var name: String
    var location: CLLocationCoordinate2D
    
    init(name: String, latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        self.name = name
        self.location = CLLocationCoordinate2DMake(latitude, longitude)
    }
}

let locations: [location] = [
    location(name: "International Residential College (IRC)", latitude: 34.019087, longitude: -118.2903097),
    location(name: "Olin Hall of Engineering (OHE)", latitude: 34.0204282, longitude: -118.2898856)
]
