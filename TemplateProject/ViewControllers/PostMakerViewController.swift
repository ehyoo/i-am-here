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
    
    var locationManager = CLLocationManager()
    let regionRadius: CLLocationDistance = 250
    var currentLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)
    var postLocation = PFGeoPoint(latitude: 0.0, longitude: 0.0)
    
    @IBOutlet weak var usernameInput: UITextField!

    @IBOutlet weak var postTextView: UITextView!

    
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
        
        //autofill the post so that it shows their username. 
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        var currentLongitude: CLLocationDegrees = manager.location.coordinate.longitude
        var currentLatitude: CLLocationDegrees = manager.location.coordinate.latitude
        currentLocation = CLLocation(latitude: currentLatitude, longitude: currentLongitude)
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        //loads alert controller when location could not be gotten
        let alertController = UIAlertController(title: "Error", message: "Could not load current location.", preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style:UIAlertActionStyle.Default, handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier{
        switch identifier {
          case "Save":
            savePost()
          default:
            println("switching")
            }
        }
    }
    
    func savePost() {
        //function that saves post
        let post = PFObject(className: "Post")
        postLocation.longitude = currentLocation.coordinate.longitude
        postLocation.latitude = currentLocation.coordinate.latitude
        post["text"] = postTextView.text
        post["location"] = postLocation
        post["displayName"] = usernameInput.text
        post["user"] = PFUser.currentUser()
        post.saveInBackground()
    }
    
    
}