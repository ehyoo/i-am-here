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

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    var locationManager = CLLocationManager()
    let regionRadius: CLLocationDistance = 250
    var currentLocation = CLLocation(latitude: 37.3318, longitude: -122.0312)
    var posts: [Post] = []
    var markers: [Marker] = []
    var selectedPost = Post()
    var dateString: String?
    
    @IBOutlet weak var mapViewer: MKMapView!
    
    
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
            
            mapViewer.delegate = self
        }
    }
    
    func makePins(posts: [Post]) {
        self.mapViewer.removeAnnotations(self.mapViewer.annotations as! [MKAnnotation])
        self.markers = []
        for x in 0..<self.posts.count {
            
        let marker = Marker(post: self.posts[x])
//            var lat = self.posts[x].location!.latitude
//            var long = self.posts[x].location!.longitude
//            let user = self.posts[x].user
//            var marker = Marker(displayName: self.posts[x].displayName!, subtitle: dateToString(self.posts[x].createdAt!), text: self.posts[x].text!, coordinate: CLLocationCoordinate2D(latitude: lat, longitude: long))
            self.markers.append(marker)
        }
        self.mapViewer.addAnnotations(self.markers)
    }
    
    func getPostsAtLocationAndMakePins(point: PFGeoPoint) {
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
                self.makePins(self.posts) //UTTER FEAR
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
        
        if posts.count == 0 {
            println(posts.count)
            getPostsAtLocationAndMakePins(refPoint)
            centerMapOnLocation(currentLocation) //we can adjust this such that it snaps back to centre later. 
            //in fact you have to put that in the else statement so it can follow the user but hey we'll see.
        }
        
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
        mapViewer.setRegion(coordinateRegion, animated: true)
    }
    
    @IBAction func unwindToSegue(segue: UIStoryboardSegue) {
        if let identifier = segue.identifier {
            switch identifier {
            case "Save":
                println("save")
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

    
}

