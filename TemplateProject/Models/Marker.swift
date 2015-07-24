//
//  Marker.swift
//  i_am_here
//
//  Created by Edward Yoo on 7/17/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//


import Foundation
import MapKit

class Marker: NSObject, MKAnnotation {
    let displayName: String
    let subtitle: String
    let coordinate: CLLocationCoordinate2D
    
    init(displayName: String, subtitle: String, coordinate: CLLocationCoordinate2D) {
        self.displayName = displayName
        self.subtitle = subtitle
        self.coordinate = coordinate
        
        super.init()
    }
    
    var title: String {
        return displayName
    }
    

    
    
}