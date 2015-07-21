//
//  Post.swift
//  i_am_here
//
//  Created by Edward Yoo on 7/14/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

import Foundation
import Parse
import MapKit


class Post: PFObject, PFSubclassing {
    @NSManaged var imageFile: PFFile
    @NSManaged var user: PFUser?
    @NSManaged var location: PFGeoPoint?
    @NSManaged var text: String?
    
    static func parseClassName() -> String {
        return "Post"
    }
    
    override init() {
        super.init()
    }
    
    override class func initialize() {
        var onceToken : dispatch_once_t = 0;
        dispatch_once(&onceToken) {
            // inform Parse about this subclass
            self.registerSubclass()
        }
    }
    
    
}