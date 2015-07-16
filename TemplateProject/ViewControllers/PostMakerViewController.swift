//
//  PostMakerViewController.swift
//  i_am_here
//
//  Created by Edward Yoo on 7/14/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

//you have to fix that thing for the text resizing for the keyboard and stuff.

import UIKit
import CoreLocation
import Parse

class PostMakerViewController: UIViewController, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var postTextView: UITextView!

    var geoLocation = PFGeoPoint(latitude: 0.0, longitude: 0.0)
    
    
    @IBAction func savePost(sender: AnyObject) {
        let post = PFObject(className: "Post")
        post["text"] = postTextView.text
        post["location"] = geoLocation //<= THIS DOESNT WORK.
        
        post.save()
    }

    
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
        }
        
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        var currentLocation: CLLocationCoordinate2D = manager.location.coordinate
        
        geoLocation.latitude = currentLocation.latitude
        geoLocation.longitude = currentLocation.longitude
        //issue with testing- coordinates are very far off. Assuming it's the simulator and not the code.
    }
    

    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        //loads alert controller when location could not be gotten
        let alertController = UIAlertController(title: "locationError", message: "Could not load current location.", preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style:UIAlertActionStyle.Default, handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}