//
//  ListingViewController.swift
//  i_am_here
//
//  Created by Edward Yoo on 7/14/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

import UIKit
import Parse

class ListingViewController: UIViewController, CLLocationManagerDelegate {
    
    var posts: [Post] = []
    var locationManager = CLLocationManager()
    let regionRadius: CLLocationDistance = 250
    var currentLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)
    var currentLocationConverted = PFGeoPoint(latitude: 0.0, longitude: 0.0)
    var selectedPost: Post?
    
    @IBOutlet weak var tableView: UITableView!
    let currentUser = PFUser.currentUser()
    
    override func viewDidLoad() {
        //incredibly hacky way to get around the two views using the segmented control
        //hides the back button 
        self.navigationItem.setHidesBackButton(true, animated: true)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        //used in background
        self.locationManager.requestAlwaysAuthorization()
        
        //used in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.requestAlwaysAuthorization()
            self.locationManager.startUpdatingLocation()
        }
    }
    
    func queryUpdateList(coordinate: PFGeoPoint) {
        //query and updating the table view list
        let postsQuery = Post.query()
        
        postsQuery!.orderByDescending("createdAt")
        //bases query based on location
        postsQuery!.whereKey("location", nearGeoPoint: currentLocationConverted, withinMiles: 0.05)
        //actual query
        postsQuery!.findObjectsInBackgroundWithBlock {(result: [AnyObject]?, error: NSError?) -> Void in
            self.posts = result as? [Post] ?? []
            self.tableView.reloadData()
        }
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        var currentLongitude: CLLocationDegrees = manager.location.coordinate.longitude
        var currentLatitude: CLLocationDegrees = manager.location.coordinate.latitude
        currentLocation = CLLocation(latitude: currentLatitude, longitude: currentLongitude)
        var currentLocationLatitude = currentLocation.coordinate.latitude
        var currentLocationLongitude = currentLocation.coordinate.longitude
        currentLocationConverted = PFGeoPoint(latitude: currentLocationLatitude, longitude: currentLocationLongitude)
        queryUpdateList(currentLocationConverted)
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        //loads alert controller when location could not be gotten
        let alertController = UIAlertController(title: "Error", message: "Could not load current location.", preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style:UIAlertActionStyle.Default, handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showFullPost" {
            let fullPostViewController = segue.destinationViewController as! FullPostViewController
            fullPostViewController.wholePost = selectedPost
        }
    }
    
}

extension ListingViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedPost = posts[indexPath.row]
        self.performSegueWithIdentifier("showFullPost", sender: self)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

// what i want but is broken
        let postAtIndex = posts[indexPath.row] as Post
        
        if postAtIndex.imageFile.getData() != nil {
            var cellWithImage = tableView.dequeueReusableCellWithIdentifier("PostCellWithImage") as! PostTableWithImageViewCell
            cellWithImage.wholePost = postAtIndex
            return cellWithImage
        } else {
            var cellWithoutImage = tableView.dequeueReusableCellWithIdentifier("PostCell") as! PostTableViewCell
            cellWithoutImage.wholePost = postAtIndex
            return cellWithoutImage
        }
    
// working but not what i want
//        let cell = tableView.dequeueReusableCellWithIdentifier("PostCell") as! PostTableViewCell
//        
//        let postAtIndex = posts[indexPath.row] as Post
//        cell.wholePost = postAtIndex
//        
//        return cell
    }
    
}



