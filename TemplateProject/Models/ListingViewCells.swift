//
//  ListingViewCells.swift
//  i_am_here
//
//  Created by Edward Yoo on 8/11/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation
import Parse

extension MapViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedPostInList = posts[indexPath.row]
        self.performSegueWithIdentifier("showFullPost", sender: self)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //dynamic rows
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 44.0
        
        // image and without image posts
        let postAtIndex = posts[indexPath.row] as Post
        
        
        if postAtIndex.imageFile.getData() != nil {
            postAtIndex.downloadImage()
            var cellWithImage = tableView.dequeueReusableCellWithIdentifier("PostCellWithImage") as! PostTableWithImageViewCell
            cellWithImage.wholePost = postAtIndex
            cellWithImage.layoutMargins = UIEdgeInsetsZero
            return cellWithImage
        } else {
            var cellWithoutImage = tableView.dequeueReusableCellWithIdentifier("PostCell") as! PostTableViewCell
            cellWithoutImage.wholePost = postAtIndex
            cellWithoutImage.layoutMargins = UIEdgeInsetsZero
            return cellWithoutImage
        }
    }
}
