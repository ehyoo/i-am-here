//
//  MapViewController.swift
//  i_am_here
//
//  Created by Edward Yoo on 7/15/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

//you have to clean up this code for annotations- tons of repitition between this and the ListingViewController

import UIKit
import MapKit
import CoreLocation
import Parse
import ConvenienceKit

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, TimelineComponentTarget {
    
    var locationManager = CLLocationManager()
    let regionRadius: CLLocationDistance = 200
    var currentLocation = CLLocation(latitude: 37.3318, longitude: -122.0312)
    var refPoint = PFGeoPoint(latitude: 37.3318, longitude: -122.0312)
    var posts: [Post] = []
//    var postsForList: [Post] = []
    var markers: [Marker] = []
    var selectedPost = Post()
    var dateString: String?
    var distances: [CLLocationDistance] = []
    var postCount: Int = 0
    var refreshControl = UIRefreshControl()
    var selectedPostInList: Post?
    var timelineComponent: TimelineComponent<Post, MapViewController>!
    
    let defaultRange = 0...4
    let additionalRangeSize = 5
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mapViewer: MKMapView!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableViewTopConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        //incredibly hacky way to switch between the two views
        //hides the back button
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        //timeline component
        timelineComponent = TimelineComponent(target: self)
        
        super.viewDidLoad()
        //used in background
        self.locationManager.requestAlwaysAuthorization()
        
        //used in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.requestAlwaysAuthorization()
            self.locationManager.startUpdatingLocation()
            
            mapViewer.delegate = self
            tableView.backgroundColor = UIColor.clearColor()
        }

        
        //refresh the list
//        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
//        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
//        tableView.addSubview(refreshControl)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        //no animation because im a scrub and i dont want to take more time into this
        self.locationManager.startUpdatingLocation()
        timelineComponent.loadInitialIfRequired()
    }
    
    func makePins(posts: [Post]) {
        self.mapViewer.removeAnnotations(self.mapViewer.annotations as! [MKAnnotation])
        self.markers = []
        for x in 0..<self.posts.count {
            
        let marker = Marker(post: self.posts[x])
            //trying to set this fucking location
            var postToHereDistance = self.locationManager.location.distanceFromLocation(marker.cllocation)
            //and getting distance of pins
            marker.distance = postToHereDistance
            
            self.markers.append(marker)
        }
        self.mapViewer.addAnnotations(self.markers) //shouldn't we have an animation here? 
    }
    
    func getPostsAtLocationAndMakePins(point: PFGeoPoint) {
        //function that queries puts into array, then makes pin.
        let postsQuery = Post.query()
        let postsQueryForList = Post.query()
        
        postsQuery!.orderByDescending("createdAt")
        postsQuery!.whereKey("location", nearGeoPoint: point, withinMiles: 50.0)
        postsQuery!.includeKey("user")
        
        postsQueryForList!.orderByDescending("createdAt")
        postsQueryForList!.whereKey("location", nearGeoPoint: point, withinMiles: 0.5)
        postsQueryForList!.includeKey("user")
//        postsQueryForList!.limit = 5
        
        //actual query
        postsQuery!.findObjectsInBackgroundWithBlock {(result: [AnyObject]?, error: NSError?) -> Void in
            if error == nil {
                self.posts = []
                for object in result! {
                    self.posts.append(object as! Post)
                }
                self.makePins(self.posts) //UTTER FEAR
            }
        }
        
//        postsQueryForList!.findObjectsInBackgroundWithBlock {(result: [AnyObject]?, error: NSError?) -> Void in
//            if error == nil {
//                self.postsForList = []
//                for object in result! {
//                    self.postsForList.append(object as! Post)
//                }
//            }
//        }
    }

    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        //converts CLLocationCoordinates to GeoLocation for Parse uploading
        var currentLongitude: CLLocationDegrees = manager.location.coordinate.longitude
        var currentLatitude: CLLocationDegrees = manager.location.coordinate.latitude
        currentLocation = CLLocation(latitude: currentLatitude, longitude: currentLongitude)
        
        var clLat = currentLocation.coordinate.latitude
        var clLong = currentLocation.coordinate.longitude
        refPoint = PFGeoPoint(latitude: clLat, longitude: clLong)
        
        var counter = 0
        
        if posts.count == 0 {
            for i in 0...7 {
                getPostsAtLocationAndMakePins(refPoint)
                centerMapOnLocation(currentLocation)
//                queryUpdateList(refPoint)
            }
                self.locationManager.stopUpdatingLocation()
        } else {
            self.locationManager.stopUpdatingLocation()
            getPostsAtLocationAndMakePins(refPoint)
//            queryUpdateList(refPoint)
        }
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        //loads alert controller when location could not be gotten
        let alertController = UIAlertController(title: "Error", message: "Could not load current location.", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "OK", style:UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        mapViewer.showsUserLocation = true
    }
    
    func centerMapOnLocation(location: CLLocation) {
        //gets map view area
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
            regionRadius * 1.0, regionRadius * 1.0)
        mapViewer.setRegion(coordinateRegion, animated: true)
    }
    
    @IBAction func unwindToSegue(segue: UIStoryboardSegue) {
        if let identifier = segue.identifier {
            switch identifier {
            case "Save":
                println("save")
            case "Post!":
                println("posting and toasting")
            default:
                println("switch")
            }
        }
    }
    
    func dateToString(date: NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy 'at' HH:mm"
        dateString = dateFormatter.stringFromDate(date)
        return dateString!
    }
    
    func refreshAnnotations() {
        self.locationManager.startUpdatingHeading()
    }
    
    @IBAction func tableViewSegmentedControlAction(sender: AnyObject) {
        if segmentedControl.selectedSegmentIndex == 0 {
            self.tableViewTopConstraint.constant = 1200
            UIView.animateWithDuration(0.3) {
                self.view.layoutIfNeeded()
            }
        } else {
            self.tableViewTopConstraint.constant = 0
            
            UIView.animateWithDuration(0.3) {
                self.view.layoutIfNeeded()
            }
        }
        
    }
    
    
//    func queryUpdateList(coordinate: PFGeoPoint) {
//        //query and updating the table view list
//        
//        ParseHelper.listingViewControllerRequest(defaultRange, currentLocationConverted: refPoint, completionBlock: {(result: [AnyObject]?, error: NSError?) -> Void in
////            self.postsForList = result as? [Post] ?? []
//            self.tableView.reloadData()})
//    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showFullPost" {
            let fullPostViewController = segue.destinationViewController as! FullPostViewController
            fullPostViewController.wholePost = selectedPostInList
        } else if segue.identifier == "showFullPostFromAnnotation" {
        let fullPostViewController = segue.destinationViewController as! FullPostViewController
        
        fullPostViewController.wholePost = selectedPost
        }
    }
    
//    func refresh(refreshControl: UIRefreshControl) {
//        queryUpdateList(refPoint)
//        refreshControl.endRefreshing()
//    }
    
    func loadInRange(range: Range<Int>, completionBlock: ([Post]?) -> Void) {
        ParseHelper.listingViewControllerRequest(range, currentLocationConverted: refPoint) {
            (result: [AnyObject]?, error: NSError?) -> Void in
            // 2
            let posts = result as? [Post] ?? []
            // 3
            completionBlock(posts)
        }
    }
    
    
}

