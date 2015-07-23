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

class MapViewController: UIViewController, CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()
    let regionRadius: CLLocationDistance = 250
    var currentLocation = CLLocation(latitude: 37.3318, longitude: -122.0312)
    var posts: [Post] = []
    var markers: [Marker] = []
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
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
            
            mapView.delegate = self
        }
    }
    
    func makePins(posts: [Post]) {
        self.mapView.removeAnnotations(self.mapView.annotations as! [MKAnnotation])
        self.markers = []
        for x in 0..<self.posts.count {
            
            var lat = self.posts[x].location!.latitude
            var long = self.posts[x].location!.longitude
            let user = self.posts[x].user
            var marker = Marker(user: "whatever", title: self.posts[x].displayName!, text: self.posts[x].text!, coordinate: CLLocationCoordinate2D(latitude: lat, longitude: long))
            self.markers.append(marker)
        }
        self.mapView.addAnnotations(self.markers)
    }
    
    func getPostAtLocation(point: PFGeoPoint) {
        //function that queries puts into array, then makes pin.
        let postsQuery = Post.query()
        postsQuery!.orderByDescending("createdAt")
        
        postsQuery!.whereKey("location", nearGeoPoint: point, withinMiles: 1.0)
        postsQuery!.includeKey("user")
        
        //actual query
        postsQuery!.findObjectsInBackgroundWithBlock {(result: [AnyObject]?, error: NSError?) -> Void in
            if error == nil {
                self.posts = []
                for object in result! {
                    self.posts.append(object as! Post)
                }
            }
        }
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        //converts CLLocationCoordinates to GeoLocation for Parse uploading
        var currentLongitude: CLLocationDegrees = manager.location.coordinate.longitude
        var currentLatitude: CLLocationDegrees = manager.location.coordinate.latitude
        currentLocation = CLLocation(latitude: currentLatitude, longitude: currentLongitude)
        var clLat = currentLocation.coordinate.latitude
        var clLong = currentLocation.coordinate.longitude
        var refPoint = PFGeoPoint(latitude: clLat, longitude: clLong)
        getPostAtLocation(refPoint)
        makePins(posts)
        
        centerMapOnLocation(currentLocation)
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        //loads alert controller when location could not be gotten
        let alertController = UIAlertController(title: "Error", message: "Could not load current location.", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "OK", style:UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func centerMapOnLocation(location: CLLocation) {
        //gets map view area
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
            regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }

}


