//
//  PostMakerViewController.swift
//  i_am_here
//
//  Created by Edward Yoo on 7/14/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

import UIKit
import CoreLocation
import Parse


class PostMakerViewController: UIViewController, CLLocationManagerDelegate, UIGestureRecognizerDelegate {
    
    var locationManager = CLLocationManager()
    let regionRadius: CLLocationDistance = 250
    var currentLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)
    var postLocation = PFGeoPoint(latitude: 0.0, longitude: 0.0)
    var photoTakingHelper: PhotoTakingHelper?
    var selectedImage: UIImage?
    
    @IBOutlet weak var usernameInput: UITextField!
    @IBOutlet weak var postTextView: UITextView!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var userLocationLabel: UILabel!
    
    override func viewDidLoad() {
        
        //some design stuff
        
        self.postTextView.layer.borderColor = StyleConstants.borderColor.CGColor
        self.postTextView.layer.borderWidth = 1.0
        self.postTextView.layer.cornerRadius = 5.0
        self.postTextView.clipsToBounds = true
        
        //then the other stuff
        super.viewDidLoad()
        //used in background
        self.locationManager.requestAlwaysAuthorization()
        
        //used in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        //hide info label
        infoLabel.hidden = true
        
        //if image view is tapped, show the image selector.
        var UITapRecognizer = UITapGestureRecognizer(target: self, action: "tappedImage:")
        UITapRecognizer.delegate = self
        self.postImageView.addGestureRecognizer(UITapRecognizer)
        self.postImageView.userInteractionEnabled = true
        
        
        //refreshing and updating location when view loads
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.requestAlwaysAuthorization()
            self.locationManager.startUpdatingLocation()
        }
        
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        //current location update and convert to pfgeopoint
        var currentLongitude: CLLocationDegrees = manager.location.coordinate.longitude
        var currentLatitude: CLLocationDegrees = manager.location.coordinate.latitude
        currentLocation = CLLocation(latitude: currentLatitude, longitude: currentLongitude)
        
        CLGeocoder().reverseGeocodeLocation(manager.location, completionHandler: { (placemarks, error) -> Void in
            
            if error != nil {
                println(error.localizedDescription)
                return
            }
            
            if placemarks.count > 0 {
                let pm = placemarks[0] as! CLPlacemark
                self.displayLocation(pm)
            }
        })
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
          case "postRewindSegue":
            savePost()
          case "showFullPost":
            println("show full post")
          default:
            println("switching")
            }
        }
    }
    
    func savePost() {
        //function that saves post
        let post = PFObject(className: "Post")
        
        //conversion of coordinates
        postLocation.longitude = currentLocation.coordinate.longitude
        postLocation.latitude = currentLocation.coordinate.latitude
        
        //post text stuff
        post["text"] = postTextView.text
        post["location"] = postLocation
        post["displayName"] = usernameInput.text
        post["user"] = PFUser.currentUser()
        
        //saving post image with error checking
        if selectedImage != nil {
            let imageData = UIImageJPEGRepresentation(selectedImage!, 1.0)
            let imageFile = PFFile(data: imageData)
            imageFile.save()
            post["imageFile"] = imageFile
        }
        
        //finally save the post
        post.saveInBackground()
    }
    
    func tappedImage(image: AnyObject) {
        //image view is tapped
        if self.uploadButton.hidden == true {
            self.postTextView.endEditing(true)
            takePhoto()
        } else {
            self.postTextView.endEditing(true)
            //dismiss your shit
        }
        
        //also dismisses the keyboard 
        
        
    }
    
    @IBAction func postButtonAction(sender: AnyObject) {
        savePost()
        self.tabBarController?.selectedIndex = 0
        usernameInput.text = nil
        postTextView.text = nil
        postImageView.image = nil
        self.uploadButton.hidden = false
        self.infoLabel.hidden = true
    }
    
    @IBAction func uploadButtonAction(sender: AnyObject) {
        //upload button is tapped
        takePhoto()
    }
    
    func takePhoto() {
        //makes an instance of PhotoTakingHelper and returns image
        photoTakingHelper = PhotoTakingHelper(viewController: self) { (image: UIImage?) in
            self.postImageView.image = image
            self.selectedImage = image!
            
            if image != nil {
                self.uploadButton.hidden = true
                self.infoLabel.hidden = false
            }
        }
    }
    
    func displayLocation(placemark: CLPlacemark) {
        //stops updating location (yo we gotta implement this in the other thigns) 
        self.locationManager.stopUpdatingLocation()
        
        //shows location in the label 
        userLocationLabel.text = "You are in: \(placemark.locality), \(placemark.administrativeArea)"
    }
    
    
    @IBAction func clearButtonAction(sender: AnyObject) {
        //clears the entire post
        usernameInput.text = nil
        postTextView.text = nil
        postImageView.image = nil
        self.uploadButton.hidden = false
    }
    
    
}