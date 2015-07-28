//
//  Marker.swift
//  i_am_here
//
//  Created by Edward Yoo on 7/17/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//


import Foundation
import MapKit
import Parse

class Marker: NSObject, MKAnnotation {
    var post: Post
    var displayName: String
    var subtitle: String
    var text: String
    var date: NSDate
    var coordinate: CLLocationCoordinate2D
    var dateString: String?

    
    init(post: Post) {
        self.post = post
        displayName = post.displayName!
        subtitle = ""
        text = post.text!
        coordinate = CLLocationCoordinate2D()
        date = post.createdAt!
        
        super.init()
        
        subtitle = self.dateToString(post.createdAt!)
        coordinate = self.convertToCLLocation(post.location!)
    }
    
    
    var title: String {
        return displayName
    }
    
    func dateToString(date: NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy 'at' HH:mm"
        dateString = dateFormatter.stringFromDate(date)
        return dateString!
    }
    
    func convertToCLLocation (point: PFGeoPoint) -> CLLocationCoordinate2D {
        var convertedCoordinate = CLLocationCoordinate2DMake(point.latitude, point.longitude)
        return convertedCoordinate
    }
    
}