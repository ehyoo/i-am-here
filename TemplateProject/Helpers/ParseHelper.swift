//
//  ParseHelper.swift
//  i_am_here
//
//  Created by Edward Yoo on 8/10/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

import Foundation
import Parse

class ParseHelper {
    
    static func listingViewControllerRequest(completionBlock: PFArrayResultBlock, currentLocationConverted: PFGeoPoint) {
        let postsQuery = Post.query()
        
        postsQuery!.orderByDescending("createdAt")
        //bases query based on location
        postsQuery!.whereKey("location", nearGeoPoint: currentLocationConverted, withinMiles: 0.5)
        //actual query
        postsQuery!.findObjectsInBackgroundWithBlock(completionBlock)
        
    }
    
}
