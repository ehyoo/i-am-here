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
    
    @IBAction func unwindToListing(segue: UIStoryboardSegue) {
      //this doesnt work
    }
    
    @IBAction func savePost(sender: AnyObject) {
        let post = PFObject(className: "Post")
        post["text"] = postTextView.text
        // post["location"] = getCurrentUserLocation() <= THIS DOESNT WORK.
        
       post.save()
    }
    
    //unwind function is retarded though so we're going to have to fix that.

    func getCurrentUserLocation() -> PFGeoPoint {
        locationManager.location.description
        }
        
        return userLocation!
    }
    ^NEITHER DOES THIS.
     IT'S RETURNING NIL WTF

    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.startUpdatingLocation()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //fuck it
    

}
