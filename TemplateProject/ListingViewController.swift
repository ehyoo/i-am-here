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
    
    @IBOutlet weak var tableView: UITableView!
    let currentUser = PFUser.currentUser()
    
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
}

extension ListingViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("PostCell") as! PostTableViewCell
        
        let wholePost = posts[indexPath.row] as Post
        cell.wholePost = wholePost
        
            //something
        
//        cell.displayNameLabel!.text = posts[indexPath.row].displayName
//        cell.postTextLabel!.text = posts[indexPath.row].text
        
        
        return cell
    }
    
}



