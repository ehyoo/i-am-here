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
    let refPoint = PFGeoPoint(latitude: 37.33240841351742, longitude: -122.0304785250445) //once again need to fix 
    var posts: [Post] = []
    var markers: [Marker] = []
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        // let currentUser = PFUser.currentUser()  < see comment below
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
            
            //querying- same as ListingViewController
            let postsQuery = Post.query()
            postsQuery!.orderByDescending("createdAt")
            //bases query based on location
            var clLat = currentLocation.coordinate.latitude
            var clLong = currentLocation.coordinate.longitude
            var refPoint = PFGeoPoint(latitude: clLat, longitude: clLong)
            //assign user location
            
            /*
            //this works but it doesn't store it in parse
            currentUser!["location"] = refPoint
            println(refPoint)
            */
            
            
            postsQuery!.whereKey("location", nearGeoPoint: refPoint, withinMiles: 1.0) //change this to be more specific
            postsQuery!.includeKey("user")
            //actual query
            postsQuery!.findObjectsInBackgroundWithBlock {(result: [AnyObject]?, error: NSError?) -> Void in
                if error == nil {
                    for object in result! {
                        self.posts.append(object as! Post)
                    }
                }

                for x in 0..<self.posts.count {

                    var lat = self.posts[x].location!.latitude
                    var long = self.posts[x].location!.longitude
                    let user = self.posts[x].user
                    
                    var marker = Marker(user: "whatever", title: self.posts[x].displayName!, text: self.posts[x].text!, coordinate: CLLocationCoordinate2D(latitude: lat, longitude: long))
                    self.markers.append(marker)
                }
                self.mapView.addAnnotations(self.markers)
            }
        }
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        //converts CLLocationCoordinates to GeoLocation for Parse uploading
        var currentLongitude: CLLocationDegrees = manager.location.coordinate.longitude
        var currentLatitude: CLLocationDegrees = manager.location.coordinate.latitude
        currentLocation = CLLocation(latitude: currentLatitude, longitude: currentLongitude)
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


