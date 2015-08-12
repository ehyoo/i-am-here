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
    var cllocation: CLLocation
    var distance: CLLocationDistance?

    
    init(post: Post) {
        self.post = post
        displayName = post.displayName!
        subtitle = ""
        text = post.text!
        coordinate = CLLocationCoordinate2D()
        date = post.createdAt!
        cllocation = CLLocation()
        distance = CLLocationDistance(0.0)
        
        super.init()
        
        subtitle = self.dateToString(post.createdAt!)
        coordinate = self.convertToCLLocation(post.location!)
        cllocation = self.CLLocationMaker(coordinate)
        
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
    
    func CLLocationMaker (point: CLLocationCoordinate2D) -> CLLocation {
        var memes = CLLocation(latitude: point.latitude, longitude: point.longitude)
        return memes
    }
    
    func pinColor() -> MKPinAnnotationColor {
        //sorts colours
        
        var hardCodedDistance = CLLocationDistance(1000.0)
        
        if self.post.user!.objectId == PFUser.currentUser()!.objectId {
            return .Green
        } else if self.distance > hardCodedDistance {
            return .Red
        } else {
            return .Purple
        }

    }
    

}