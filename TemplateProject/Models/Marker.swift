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
    let user: String
    let title: String
    let text: String
    let coordinate: CLLocationCoordinate2D
    
    init(user: String, title: String, text: String, coordinate: CLLocationCoordinate2D) {
        self.user = user
        self.title = title
        self.text = text
        self.coordinate = coordinate
        
        super.init()
    }
    
    var subtitle: String {
        return text
    }

    
    
}